resource "aws_s3_bucket" "this" {
  for_each = var.loki_buckets

  bucket        = "${local.bucket_id_base}-${each.value.name}"
  force_destroy = true

  tags = {
    "Description"                  = "Loki ${each.value.name}"
    "Name"                         = "${local.bucket_id_base}-${each.value.name}"
    "Unikie:DevSecOps:ClusterName" = var.cluster_id
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  for_each = var.loki_buckets

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = var.loki_buckets

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.loki_buckets[each.key].arn // Lower encryption costs with less KMS Queries
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  for_each = var.loki_buckets

  bucket = aws_s3_bucket.this[each.key].id

  versioning_configuration {
    status = each.value.versioning
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = var.loki_buckets

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    id     = each.value.name
    status = "Enabled"

    filter {
      prefix = each.value.name
    }

    transition {
      days          = 60
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = each.value.expiration_days
    }
  }
}
