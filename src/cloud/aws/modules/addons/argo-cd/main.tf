# ---------------------------------------------------------------------------------------------------------------------
# ARGOCD HELM CHART
# Requires Elasticache Redis
# -> modules/elasticache
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
  timeout          = 300
  verify           = false
  wait             = true
  wait_for_jobs    = true

  chart      = "argo-cd"
  name       = local.name_label
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      CHART_VERSION  = var.chart_version
      INGRESS_URL    = var.ingress_url
      IRSA_ARN       = aws_iam_role.this.arn
      IRSA_NAME      = aws_iam_role.this.name
      NAMESPACE      = var.namespace
      NAME_LABEL     = local.name_label
      REDIS_ENDPOINT = local.redis.endpoint
      REDIS_SECRET   = "redis-password"
      STAGE          = local.stage
      }
    )
  ]
}

resource "kubectl_manifest" "secret_store" {
  yaml_body = templatefile("${path.module}/templates/secret-store.yaml",
    {
      IRSA_NAME         = aws_iam_role.this.name
      NAMESPACE         = var.namespace
      REGION            = data.aws_region.current.region
      SECRET_STORE_NAME = "argocd-secret"
      STAGE             = local.stage
      VERSION           = "AWSLATEST"
    }
  )
}

resource "kubectl_manifest" "external_secret_admin" {
  yaml_body = templatefile("${path.module}/templates/external-secret.yaml",
    {
      CREATION_POLICY   = "Merge"
      EXT_SECR_NAME     = "${local.name_label}-secrets"
      NAMESPACE         = var.namespace
      SECRET_KEY        = "admin.password"
      SECRET_STORE_NAME = "argocd-secret"
      STAGE             = local.stage
      TARGET_NAME       = "argocd-secret"
      VAULT_NAME        = var.vault_admin
      VAULT_PROPERTY    = "admin.password"
      VERSION           = "AWSLATEST"
    }
  )
}

resource "kubectl_manifest" "external_secret_redis" {
  yaml_body = templatefile("${path.module}/templates/external-secret.yaml",
    {
      CREATION_POLICY   = "Owner"
      EXT_SECR_NAME     = "${local.name_label}-redis"
      NAMESPACE         = var.namespace
      SECRET_KEY        = "redis-password"
      SECRET_STORE_NAME = "argocd-secret"
      STAGE             = local.stage
      TARGET_NAME       = "redis-password"
      VAULT_NAME        = var.vault_redis
      VAULT_PROPERTY    = "password"
      VERSION           = "AWSLATEST"
    }
  )
}
