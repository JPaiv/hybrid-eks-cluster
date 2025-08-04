resource "aws_kms_key" "flow_logs" {
  description = "VPC ${var.id_label} IP Traffic Flow Logs S3 Bucket KMS CM"

  // -- Lifecycle
  deletion_window_in_days = 7
  enable_key_rotation     = true

  // -- Usage
  key_usage    = "ENCRYPT_DECRYPT"
  multi_region = false

  tags = {
    "Description" = "VPC ${var.id_label} IP Traffic Flow Logs S3 Bucket KMS CM"
    "Name"        = "s3/${var.id_label}-vpc-flow-logs"
  }
}

resource "aws_kms_alias" "flow_logs" {
  name          = "alias/s3/${var.id_label}-vpc-flow-logs"
  target_key_id = aws_kms_key.flow_logs.key_id
}

resource "aws_kms_key_policy" "flow_logs" {
  key_id = aws_kms_key.flow_logs.id
  policy = data.aws_iam_policy_document.flow_logs_kms_permissions.json
}

data "aws_iam_policy_document" "flow_logs_kms_permissions" {
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
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }

  statement {
    effect = "Allow"
    sid    = "Enable VPC Flow Logs Key Usage"

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

    principals {
      type = "Service"
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
    }
  }
}
