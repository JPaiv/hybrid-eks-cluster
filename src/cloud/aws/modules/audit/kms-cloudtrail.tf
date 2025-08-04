resource "aws_kms_key" "trail" {
  description = "Cloudtrail ${local.name_label} and S3"

  // -- Lifecycle
  deletion_window_in_days = 7
  enable_key_rotation     = true

  // -- Usage
  key_usage    = "ENCRYPT_DECRYPT"
  multi_region = false

  tags = {
    "Description"                       = "Cloudtrail ${local.name_label} and S3"
    "Name"                              = "cloudtrail/${local.name_label}"
    "Unikie:InfoSec:DataClassification" = "Extreme"
  }
}

resource "aws_kms_alias" "trail" {
  name          = "alias/cloudtrail/${local.name_label}"
  target_key_id = aws_kms_key.trail.key_id
}

resource "aws_kms_key_policy" "trail" {
  key_id = aws_kms_key.trail.id
  policy = data.aws_iam_policy_document.trail_kms_permissions.json
}

// ref: https://docs.aws.amazon.com/awscloudtrail/latest/userguide/default-kms-key-policy.html
data "aws_iam_policy_document" "trail_kms_permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "Enable IAM User Permissions"

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }

  statement {
    effect = "Allow"
    sid    = "Allow Cloudtrail To Encrypt Logs"

    actions = [
      "kms:GenerateDataKey*",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*",
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

  statement {
    effect = "Allow"
    sid    = "Allow Cloudtrail To Describe Key"

    actions = [
      "kms:DescribeKey",
    ]

    resources = [
      "*",
    ]

    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }
  }

  statement {
    effect = "Allow"
    sid    = "Allow Principals Account To Decrypt Log Files"

    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values = [
        "${data.aws_caller_identity.current.account_id}",
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = [
        "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*",
      ]
    }

    principals {
      type = "AWS"
      identifiers = [
        "*",
      ]
    }
  }

  statement {
    effect = "Allow"
    sid    = "Allow KMS Key Alias Creation During Setup"

    actions = [
      "kms:CreateAlias",
    ]

    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/${aws_kms_key.trail.key_id}",
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "ec2.${data.aws_region.current.name}.amazonaws.com",
      ]
    }

    principals {
      type = "AWS"
      identifiers = [
        "*",
      ]
    }
  }
}
