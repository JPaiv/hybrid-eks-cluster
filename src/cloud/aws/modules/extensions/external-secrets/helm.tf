// -- Install External-secrets Helm Chart
// ref: https://github.com/external-secrets/external-secrets/blob/main/deploy/charts/external-secrets/values.yaml
resource "helm_release" "external_secrets" {
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
        chart_version = var.chart_version
        chart_version = var.chart_version
        name_label    = local.name_label
        irsa_arn      = aws_iam_role.this.arn
        irsa_name     = aws_iam_role.this.name
        stage         = local.stage
      }
    )
  ]
}
