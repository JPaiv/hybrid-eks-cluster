# ---------------------------------------------------------------------------------------------------------------------
# AWS SECRETS MANAGER SECRET
# Passwords are  autocreated only during the initial deployment
# Afterwards all changes must be manual
# ---------------------------------------------------------------------------------------------------------------------

# Generate passwords using AWS service
data "aws_secretsmanager_random_password" "passwords" {
  for_each = var.secrets

  exclude_characters         = try(each.value.exclude_characters, null)
  exclude_punctuation        = each.value.exclude_punctuation
  password_length            = each.value.password_length
  require_each_included_type = try(each.value.require_each_type, null)
}

locals {
  secrets = {
    for k, v in var.secrets :
    v.name => data.aws_secretsmanager_random_password.passwords[k].random_password
  }
  secrets_json = jsonencode(local.secrets)
}

resource "aws_secretsmanager_secret" "this" {
  description                    = var.description
  force_overwrite_replica_secret = true
  kms_key_id                     = aws_kms_key.this.arn # Use ARN instead of ID to prevent recreation loop
  name                           = var.vault_name

  tags = merge(
    var.abac_tags,
    {
      "Description" = var.description
      "Name"        = var.vault_name
    }
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = local.secrets_json

  lifecycle {
    ignore_changes = [
      secret_string,
    ]
  }
}
