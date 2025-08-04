resource "helm_release" "authentik" {
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = false
  force_update     = true
  recreate_pods    = true
  replace          = true
  reset_values     = true
  reuse_values     = false
  skip_crds        = false
  timeout          = 300
  verify           = false
  wait             = true
  wait_for_jobs    = true

  chart      = "authentik"
  name       = "authentik"
  namespace  = var.namespace
  repository = "https://charts.goauthentik.io/"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        chart_version  = var.chart_version
        email_pass     = local.ses_params.password
        email_username = local.ses_params.key
        id_label       = local.id_label
        rds_host       = local.rds_params.endpoint
        rds_name       = local.rds_params.name
        rds_pass       = jsondecode(data.aws_secretsmanager_secret_version.rds_pass.secret_string)["password"]
        rds_port       = local.rds_params.port
        redis_host     = local.redis_params.endpoint
        redis_pass     = jsondecode(data.aws_secretsmanager_secret_version.redis_pass.secret_string)["password"]
        redis_port     = local.redis_params.port
        secret_key     = jsondecode(data.aws_secretsmanager_secret_version.skey.secret_string)["password"]
        stage          = local.stage
      }
    )
  ]
}
