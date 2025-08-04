// -- Authentik Postgres RDS
data "aws_ssm_parameter" "rds" {
  name = var.rds_ssm_param_name
}

data "aws_ssm_parameter" "redis" {
  name = var.redis_ssm_param_name
}


data "aws_secretsmanager_secret" "skey" {
  name = var.skey_secr_name
}

data "aws_secretsmanager_secret_version" "skey" {
  secret_id = data.aws_secretsmanager_secret.skey.id
}

data "aws_secretsmanager_secret" "rds_pass" {
  name = var.rds_pass_secr_name
}

data "aws_secretsmanager_secret_version" "rds_pass" {
  secret_id = data.aws_secretsmanager_secret.rds_pass.id
}

data "aws_secretsmanager_secret" "redis_pass" {
  name = var.redis_pass_secr_name
}

data "aws_secretsmanager_secret_version" "redis_pass" {
  secret_id = data.aws_secretsmanager_secret.redis_pass.id
}

# -- ArgoCD Elasticache Redis parameters
data "aws_ssm_parameter" "ses" {
  name = var.ses_secr_name
}
