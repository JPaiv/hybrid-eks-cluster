resource "aws_kms_key" "cw" {
  # -- General
  description = "KMS key to encrypt CloudWatch logs for ElastiCache: ${local.id_label}"
  policy      = data.aws_iam_policy_document.cw.json # Attach the policy here

  # -- Lifecycle
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    "Name"        = "cw/elasticache/${local.id_label}"
    "Description" = "KMS key for all ElastiCache CloudWatch logs for ${local.id_label}"
  }
}

resource "aws_kms_alias" "cw" {
  name          = "alias/cw/elasticache/${local.id_label}"
  target_key_id = aws_kms_key.cw.key_id
}

data "aws_iam_policy_document" "cw" {

  statement {
    sid    = "EnableIAMUserPermissions"
    effect = "Allow"

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
    sid    = "AllowCloudwatchLogEncryption"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        for log_config in var.elasticache_logs : "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/elasticache/${local.id_label}/${log_config.log_type}"
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
