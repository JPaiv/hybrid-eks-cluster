# ---------------------------------------------------------------------------------------------------------------------
# ENCRYPT VPC IP TRAFFIC FLOW LOGS S3 BUCKET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "this" {
  deletion_window_in_days = 7
  description             = "VPC Flow Logs S3 encryption"
  enable_key_rotation     = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false

  tags = {
    "Description" = "VPC Flow Logs S3 encryption"
    "Name"        = "s3/${local.name_label}"
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/s3/${var.id_label}-vpc-flow-logs"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = data.aws_iam_policy_document.permissions.json
}

data "aws_iam_policy_document" "permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "Allow IAM Root User"

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
    sid    = "Allow VPC Flow Logs service to use key for S3"

    actions = [
      "kms:Decrypt",
      "kms:Describe*",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:*",
      ]
    }

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
        "logs.eu-central-1.amazonaws.com",
      ]
    }

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com",
      ]
    }
  }
}
