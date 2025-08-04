resource "aws_cloudwatch_log_group" "this" {
  kms_key_id        = aws_kms_key.cloudwatch.arn // -- Hashicorp has fucked up once again, so use the KSM Key ARN instead of the Key ID
  name              = local.name_label
  retention_in_days = 30

  tags = {
    "Description" = "Cloudtrail ${local.name_label} Log Group"
    "Name"        = local.name_label
  }
}
