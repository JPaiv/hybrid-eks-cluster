resource "aws_cloudwatch_log_group" "this" {
  kms_key_id        = aws_kms_key.cloudwatch.arn # Use ARN, even if it says key_id to prevent recreation bug
  name              = local.name_label
  retention_in_days = 30

  tags = {
    "Description" = "Cloudtrail ${local.name_label} Log Group"
    "Name"        = local.name_label
  }
}
