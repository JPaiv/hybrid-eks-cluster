resource "aws_kms_key" "cache" {
  // -- General
  description = "EC Redis ${local.id_label}"

  // -- Lifecycle
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    "Description" = "EC Redis ${local.id_label}"
    "Name"        = "elasticache/${local.id_label}"
  }
}

resource "aws_kms_alias" "cache" {
  name          = "alias/elasticache/${local.id_label}"
  target_key_id = aws_kms_key.cache.key_id
}
