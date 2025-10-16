# ---------------------------------------------------------------------------------------------------------------------
# KUBE-PROMETHEUS-STACK HELM CHART
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

  chart      = "kube-prometheus-stack"
  name       = local.name_label
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = var.chart_vers

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        CHART_VERSION = var.chart_vers
        INGRESS_URL   = var.ingress_url
        IRSA_ARN      = aws_iam_role.this.arn
        IRSA_NAME     = aws_iam_role.this.name
        NAME_LABEL    = local.name_label
        STAGE         = local.stage
      }
    )
  ]

  depends_on = [
    kubectl_manifest.external_secret,
    kubectl_manifest.secret_store,
    kubectl_manifest.storage_class,
  ]
}

resource "kubectl_manifest" "storage_class" {
  yaml_body = templatefile("${path.module}/templates/storage-class.yaml", {
    NAMESPACE  = var.namespace
    NAME_LABEL = local.name_label
    STAGE      = local.stage
    }
  )
}

resource "kubectl_manifest" "secret_store" {
  yaml_body = templatefile("${path.module}/templates/secret-store.yaml",
    {
      IRSA_NAME  = aws_iam_role.this.name
      NAMESPACE  = var.namespace
      REGION     = data.aws_region.current.region
      NAME_LABEL = local.name_label
      STAGE      = local.stage
      VERSION    = "AWSLATEST"
    }
  )
}

resource "kubectl_manifest" "external_secret" {
  yaml_body = templatefile("${path.module}/templates/external-secret.yaml",
    {
      NAMESPACE  = var.namespace
      NAME_LABEL = local.name_label
      STAGE      = local.stage
      VAULT_NAME = var.vault_name
      VERSION    = "AWSLATEST"
    }
  )
}
