resource "aws_kms_key" "this" {
  deletion_window_in_days = 30
  description             = "RDS Postgresql instance ${local.id_label}"
  enable_key_rotation     = true

  tags = {
    "Description" = "RDS Postgresql instance ${local.id_label}"
    "Name"        = "rds/${local.id_label}"
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/rds/${local.id_label}"
  target_key_id = aws_kms_key.this.key_id
}
