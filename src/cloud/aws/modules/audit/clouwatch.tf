resource "aws_cloudwatch_log_group" "this" {
  kms_key_id        = aws_kms_key.cloudwatch.arn // -- Hashicorp has fucked up once again, so use the KSM Key ARN instead of the Key ID
  name              = local.id_label
  retention_in_days = 30

  tags = {
    "Description" = "Cloudtrail Log Group Encryption"
    "Name"        = local.id_label
  }
}
