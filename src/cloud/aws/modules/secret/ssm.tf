resource "aws_ssm_parameter" "this" {
  description = "Secret and KMS Key ARNs"
  name        = "/secret/${var.vault_name}"
  type        = "String"

  value = jsonencode(
    {
      kms_arn    = aws_kms_key.this.arn
      vault_arn  = aws_secretsmanager_secret.this.arn
      vault_name = aws_secretsmanager_secret.this.name
    }
  )

  tags = merge(
    var.abac_tags,
    {
      "Description" = "Secret and KMS params"
      "Name"        = "/secret/${var.vault_name}"
    }
  )
}
