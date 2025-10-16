# ---------------------------------------------------------------------------------------------------------------------
# LOKI CHUNKS AND RULER S3 STORAGE
# Chunks are compressed log data
# Chunks bucket has both logs data and index
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  for_each = var.loki_buckets

  bucket        = "${local.bucket_id_base}-${each.value.name}"
  force_destroy = var.bucket_force_destroy

  tags = {
    "Description" = "Loki ${each.value.name} Storage"
    "Name"        = "${local.bucket_id_base}-${each.value.name}"
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
      kms_master_key_id = aws_kms_key.this[each.key].arn
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
      days          = 7
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = each.value.expiration_days
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  for_each = var.loki_buckets

  bucket = aws_s3_bucket.this[each.key].id
  policy = data.aws_iam_policy_document.s3_permissions[each.key].json
}

data "aws_iam_policy_document" "s3_permissions" {
  for_each = var.loki_buckets

  policy_id = "Permissions"
  version   = "2012-10-17"

  statement {
    effect = "Deny"
    sid    = "Enforce Secure Connection"

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.this[each.key].arn}/*",
      aws_s3_bucket.this[each.key].arn,
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false",
      ]
    }

    principals {
      type = "*"
      identifiers = [
        "*",
      ]
    }
  }
}
