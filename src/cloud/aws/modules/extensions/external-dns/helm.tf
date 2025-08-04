resource "helm_release" "external_dns" {
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
  name       = local.name_label
  namespace  = var.namespace
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        chart_version = var.chart_version
        irsa_arn      = aws_iam_role.this.arn
        irsa_name     = aws_iam_role.this.name
        region        = data.aws_region.current.name
        stage         = local.stage
      }
    )
  ]

  set = [
    {
      name  = "zoneType"
      value = "public"
    },
    {
      name  = "txtOwnerId"
      value = data.aws_route53_zone.this.zone_id
    }
  ]
}
