# -- Current region
data "aws_region" "current" {}

# -- Accound ID
data "aws_caller_identity" "current" {}

# -- ArgoCD Elasticache Redis parameters
data "aws_ssm_parameter" "this" {
  name = var.redis_ssm_name
}

// -- Elasticache Redis password
data "aws_secretsmanager_secret" "redis" {
  name = var.redis_pass_secr_name
}

data "aws_secretsmanager_secret_version" "redis" {
  secret_id = data.aws_secretsmanager_secret.redis.id
}

data "aws_secretsmanager_secret" "admin_pass" {
  name = "main-ec1-prod-secrets/argocd-admin-pass"
}

data "aws_secretsmanager_secret_version" "admin_pass" {
  secret_id = data.aws_secretsmanager_secret.admin_pass.id
}
