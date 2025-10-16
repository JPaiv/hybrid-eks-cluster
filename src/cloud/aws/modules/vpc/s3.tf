# ---------------------------------------------------------------------------------------------------------------------
# STORAGE IP TRAFFIC FLOW LOGS
# 7 days in the standard before transition to the Glacier Deep Archive
# Expiration in 5 years
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  bucket        = local.name_label
  force_destroy = var.s3_force_destroy

  tags = {
    "Description" = "VPC network traffic logs storage"
    "Name"        = local.name_label
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "Standard to Glacier Deep Archive after one week and expiration after five years"
    status = "Enabled"

    filter {
      prefix = "AWSLogs/"
    }

    expiration {
      days = 1826 # 5 years
    }

    transition {
      days          = 7 # 1 week
      storage_class = "GLACIER_IR"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket_permissions.json
}

data "aws_iam_policy_document" "bucket_permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "Allow Flow Logs Write"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control",
      ]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:*",
      ]
    }

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com",
      ]
    }
  }

  statement {
    effect = "Allow"
    sid    = "Allow Flow Logs ACL Read"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      aws_s3_bucket.this.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:*",
      ]
    }

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com",
      ]
    }
  }

  statement {
    effect = "Deny"
    sid    = "Enforce Secure Connection"

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
      aws_s3_bucket.this.arn,
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
