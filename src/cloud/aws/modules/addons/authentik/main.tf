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
  timeout          = 400
  verify           = false
  wait             = true
  wait_for_jobs    = true

  chart      = "authentik"
  name       = local.name_label
  namespace  = var.namespace
  repository = "https://charts.goauthentik.io/"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        CHART_VERSION = var.chart_version
        IRSA_NAME     = aws_iam_role.this.name
        NAME_LABEL    = local.name_label
        RDS_HOST      = local.rds_params.endpoint
        RDS_NAME      = local.rds_params.name
        RDS_PORT      = local.rds_params.port
        REDIS_HOST    = local.redis_params.endpoint
        REDIS_PORT    = local.redis_params.port
        SECRET_LABEL  = local.secret_label
        STAGE         = local.stage
        INGRESS_URL   = var.ingress_url
      }
    )
  ]

  depends_on = [
    kubectl_manifest.external_secret,
    kubectl_manifest.secret_store,
    kubectl_manifest.service_account,
  ]
}

resource "kubectl_manifest" "service_account" {
  yaml_body = templatefile("${path.module}/templates/service-account.yaml",
    {
      CHART_VERSION = var.chart_version
      IRSA_ARN      = aws_iam_role.this.arn
      IRSA_NAME     = aws_iam_role.this.name
      NAMESPACE     = var.namespace
      SECRET_LABEL  = local.secret_label
      STAGE         = local.stage
    }
  )
}

resource "kubectl_manifest" "secret_store" {
  yaml_body = templatefile("${path.module}/templates/secret-store.yaml",
    {
      IRSA_NAME    = aws_iam_role.this.name
      NAMESPACE    = var.namespace
      REGION       = data.aws_region.current.region
      SECRET_LABEL = local.secret_label
      STAGE        = local.stage
      VERSION      = "AWSLATEST"
    }
  )
}

resource "kubectl_manifest" "external_secret" {
  yaml_body = templatefile("${path.module}/templates/external-secret.yaml",
    {
      CREATION_POLICY = "Owner"
      NAMESPACE       = var.namespace
      SECRET_LABEL    = local.secret_label
      STAGE           = local.stage
      VAULT_REDIS     = var.vault_redis
      VAULT_RDS       = var.vault_rds
      VAULT_SKEY      = var.vault_skey
      VERSION         = "AWSLATEST"
    }
  )

  depends_on = [
    kubectl_manifest.secret_store,
  ]
}
