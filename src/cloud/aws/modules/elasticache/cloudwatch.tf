# ---------------------------------------------------------------------------------------------------------------------
# ELASTICACHE REDIS ENGINE AND SLOW LOGS
# KMS Key ID changes during each deployment for some unknown reason
# -> Use ARN, because it remains the same
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "this" {
  for_each = var.elasticache_logs

  kms_key_id        = aws_kms_key.cw.arn # Use ARN even though the attribute wants the id
  log_group_class   = each.value.log_group_class
  name              = "/elasticache/${local.id_label}/${each.value.log_type}"
  retention_in_days = each.value.retention_in_days

  tags = {
    "Description" = "Elasticache ${each.value.log_type} logs"
    "Name"        = "/elasticache/${local.id_label}/${each.value.log_type}"
  }
}
