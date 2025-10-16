# ---------------------------------------------------------------------------------------------------------------------
# EXTERNAL DNS HELM CHART
# Install external-dns controller
# Namespace: kube-system
# -> Has all the mission-critical addons
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

  chart      = "external-dns"
  name       = local.id_label
  namespace  = var.namespace
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        CHART_VERSION = var.chart_version
        IRSA_ARN      = aws_iam_role.this.arn
        IRSA_NAME     = aws_iam_role.this.name
        STAGE         = local.stage
        TXT_OWNER_IP  = data.aws_route53_zone.this.zone_id
        REGION        = data.aws_region.current.region
      }
    )
  ]
}
