data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "this" {
  name = var.pass_secr_name
}

data "aws_secretsmanager_secret_version" "this" {
  secret_id = data.aws_secretsmanager_secret.this.id
}
