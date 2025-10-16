resource "aws_s3_bucket" "trail" {
  bucket        = local.name_label
  force_destroy = false

  tags = {
    "Description" = "Cloudtrail ${local.name_label} Logs Storage"
    "Name"        = local.name_label
  }
}

resource "aws_s3_bucket_ownership_controls" "trail" {
  bucket = aws_s3_bucket.trail.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "trail" {
  bucket = aws_s3_bucket.trail.id

  versioning_configuration {
    mfa_delete = "Disabled"
    status     = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "trail" {
  bucket = aws_s3_bucket.trail.bucket

  rule {
    id     = "Transit to Glacier Deep Archive After Three months and Expiration in Five Years"
    status = "Enabled"

    expiration {
      days = 1826 # 5 years
    }

    filter {
      prefix = "ctrail/"
    }

    transition {
      days          = 90 # 3 months
      storage_class = "DEEP_ARCHIVE"
    }
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "trail" {
  bucket = aws_s3_bucket.trail.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.trail.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "trail" {
  bucket = aws_s3_bucket.trail.id
  policy = data.aws_iam_policy_document.trail_permissions.json
}

data "aws_iam_policy_document" "trail_permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableCloudtrailRead"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      aws_s3_bucket.trail.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${local.name_label}",
      ]
    }

    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }
  }

  statement {
    effect = "Allow"
    sid    = "EnableCloudtrailWrite"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.trail.id}/${local.ctrail_s3_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cloudtrail:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:trail/${local.name_label}",
      ]
    }

    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }
  }
}
