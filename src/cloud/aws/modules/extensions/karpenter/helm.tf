resource "helm_release" "karpenter" {
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = false
  force_update     = true
  recreate_pods    = true
  replace          = true
  reset_values     = true
  reuse_values     = false
  skip_crds        = false
  timeout          = 600
  verify           = false
  wait             = true
  wait_for_jobs    = true

  chart      = "karpenter"
  name       = local.name_label
  namespace  = var.namespace
  repository = "oci://public.ecr.aws/karpenter"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        chart_version    = var.chart_version
        cluster_endpoint = var.cluster_endpoint
        cluster_id       = var.cluster_id
        irsa_arn         = aws_iam_role.irsa.arn
        irsa_name        = aws_iam_role.irsa.name
        queue_name       = aws_sqs_queue.karpenter.name
        region           = data.aws_region.current.name
        stage            = local.stage
      }
    )
  ]
}

resource "kubectl_manifest" "node_class" {
  yaml_body = templatefile("${path.module}/templates/node-class.yaml",
    {
      cluster_id      = var.cluster_id
      namespace       = var.namespace
      node_class_name = "bottlerocket"
      node_role_arn   = var.node_role_arn
      node_role_name  = var.node_role_name
      stage           = local.stage
    }
  )
}

resource "kubectl_manifest" "node_pool" {
  yaml_body = templatefile("${path.module}/templates/node-pool.yaml",
    {
      cluster_id      = var.cluster_id
      node_class_name = "bottlerocket"
      node_pool_name  = "bottlerocket"
      stage           = local.stage
    }
  )

  depends_on = [
    kubectl_manifest.node_class
  ]
}
