resource "aws_kms_key" "loki_buckets" {
  for_each = var.loki_buckets

  deletion_window_in_days = 30
  description             = "Loki ${each.value.name} S3 Bucket"
  enable_key_rotation     = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Description" = "Loki ${each.value.name} S3 Bucket"
    "Name"        = "s3/${local.bucket_id_base}-${each.value.name}"
  }
}

resource "aws_kms_alias" "loki_buckets" {
  for_each = var.loki_buckets

  name          = "alias/s3/${local.bucket_id_base}-${each.value.name}"
  target_key_id = aws_kms_key.loki_buckets[each.key].key_id
}
