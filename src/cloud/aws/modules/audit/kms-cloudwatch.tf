resource "aws_kms_key" "cloudwatch" {
  description = "Cloudwatch ${local.id_label} Log Group"

  // -- Lifecycle
  deletion_window_in_days = 7
  enable_key_rotation     = true

  // -- Usage
  key_usage    = "ENCRYPT_DECRYPT"
  multi_region = false

  tags = {
    "Description"                       = "Cloudwatch ${local.id_label} Log Group"
    "Name"                              = "cloudwatch/${local.id_label}"
    "Unikie:InfoSec:DataClassification" = "Extreme"
  }
}

resource "aws_kms_alias" "cloudwatch" {
  name          = "alias/cloudwatch/${local.id_label}"
  target_key_id = aws_kms_key.cloudwatch.key_id
}

resource "aws_kms_key_policy" "cloudwatch" {
  key_id = aws_kms_key.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}

// ref: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html
data "aws_iam_policy_document" "cloudwatch" {
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
    sid    = "Enable Cloudwatch Log Encryption"

    actions = [
      "kms:Decrypt*",
      "kms:Describe*",
      "kms:Encrypt*",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
      ]
    }

    principals {
      type = "Service"
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com",
      ]
    }
  }
}
