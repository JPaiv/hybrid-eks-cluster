// -- Current region
data "aws_region" "current" {}

// -- Account ID
data "aws_caller_identity" "current" {}

// -- Get the Grafana password from the AWS Secrets Manager
// -- Secret is created using TF secrets module
// -- Password version is set manually to prevent TF from hard-coding passwords into the state file
data "aws_secretsmanager_secret" "this" {
  name = var.admin_pass_secr_name
}

data "aws_secretsmanager_secret_version" "this" {
  secret_id = data.aws_secretsmanager_secret.this.id
}
