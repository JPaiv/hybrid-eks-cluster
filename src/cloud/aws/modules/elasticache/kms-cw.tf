resource "aws_kms_key" "cw" {
  description             = "CM KMS key for all ElastiCache logs in Cloudwatch"
  policy                  = data.aws_iam_policy_document.cw.json
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    "Name"        = "cw/elasticache/${local.id_label}"
    "Description" = "CM KMS key for all ElastiCache logs in Cloudwatch"
  }
}

resource "aws_kms_alias" "cw" {
  name          = "alias/cw/elasticache/${local.id_label}"
  target_key_id = aws_kms_key.cw.key_id
}

data "aws_iam_policy_document" "cw" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "Allow IAM User"

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
        for log_config in var.elasticache_logs : "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/elasticache/${local.id_label}/${log_config.log_type}"
      ]
    }

    principals {
      type = "Service"
      identifiers = [
        "logs.${data.aws_region.current.region}.amazonaws.com",
      ]
    }
  }
}
