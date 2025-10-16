
# ---------------------------------------------------------------------------------------------------------------------
# KARPENTER HELM CHART
# Install Karpenter Controller on the EKS Managed Node Group
# Only use Bottlerocket OS
# ---------------------------------------------------------------------------------------------------------------------

resource "helm_release" "this" {
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = false
  force_update     = true
  recreate_pods    = true
  replace          = true
  reset_values     = true
  reuse_values     = false
  skip_crds        = false
  timeout          = 200
  verify           = false
  wait             = true
  wait_for_jobs    = true

  chart      = "karpenter"
  name       = "${var.namespace}-karpenter"
  namespace  = var.namespace
  repository = "oci://public.ecr.aws/karpenter"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        CHART_VERSION    = var.chart_version
        CLUSTER_ENDPOINT = var.cluster_endpoint
        CLUSTER_ID       = var.cluster_id
        IRSA_ARN         = aws_iam_role.irsa.arn
        IRSA_NAME        = aws_iam_role.irsa.name
        QUEUE_NAME       = aws_sqs_queue.this.name
        REGION           = data.aws_region.current.region
        STAGE            = local.stage
      }
    )
  ]

  depends_on = [
    aws_iam_role_policy_attachment.irsa,
  ]
}

resource "kubectl_manifest" "node_class" {
  yaml_body = templatefile("${path.module}/templates/node-class.yaml",
    {
      CHART_VERSION  = var.chart_version
      CLUSTER_ID     = var.cluster_id
      NAME_LABEL     = local.node_name_label
      NODE_ROLE_ARN  = var.node_role_arn
      NODE_ROLE_NAME = var.node_role_name
      STAGE          = local.stage
    }
  )

  depends_on = [
    helm_release.this,
  ]
}

resource "kubectl_manifest" "node_pool" {
  yaml_body = templatefile("${path.module}/templates/node-pool.yaml",
    {
      CHART_VERSION = var.chart_version
      CLUSTER_ID    = var.cluster_id
      NAME_LABEL    = local.node_name_label
      STAGE         = local.stage
    }
  )

  depends_on = [
    helm_release.this,
    kubectl_manifest.node_class,
  ]
}
