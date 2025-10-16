# ---------------------------------------------------------------------------------------------------------------------
# EXTERNAL SECRETS HELM CHART
# ref: https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html
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

  chart      = "external-secrets"
  name       = local.name_label
  namespace  = var.namespace
  repository = "https://charts.external-secrets.io"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        CHART_VERSION = var.chart_version
        REGION        = data.aws_region.current.region
        IRSA_ARN      = aws_iam_role.this.arn
        IRSA_NAME     = aws_iam_role.this.name
        STAGE         = local.stage
      }
    )
  ]
}
