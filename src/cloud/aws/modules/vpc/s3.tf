resource "aws_s3_bucket" "this" {
  bucket        = "${var.id_label}-vpc-flow-logs"
  force_destroy = false

  tags = {
    "Description" = "VPC ${var.id_label} IP Traffic Flow Logs S3 delivery storage"
    "Name"        = "${var.id_label}-vpc-flow-logs"
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
      kms_master_key_id = aws_kms_key.flow_logs.arn
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
    id     = "Glacier Transition After a Week and Expiration After 5 Years"
    status = "Enabled"

    filter {
      prefix = "AWSLogs/"
    }

    expiration {
      days = 1826 // -- 5 years
    }

    transition {
      days          = 7 // -- 1 week
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
    sid = "EnableWriteFlowLogs"

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

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com",
      ]
    }
  }

  statement {
    sid = "EnableReadAcl"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      aws_s3_bucket.this.arn,
    ]

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com",
      ]
    }
  }

  statement {
    effect = "Deny"
    sid    = "EnforceSecureOnlyAccess"

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
