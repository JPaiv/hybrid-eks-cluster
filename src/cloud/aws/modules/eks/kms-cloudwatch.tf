# ---------------------------------------------------------------------------------------------------------------------
# EKS CLUSTER CONTROL PLANE LOGS CLOUDWACH LOG GROUP CMKMS
# Encrypt EKS Cluster control plane logs Cloudwatch Log Group at rest
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "cloudwatch" {
  deletion_window_in_days = 30
  description             = "EKS Cluster Control Plane Logs Cloudwatch Log Group CMKMS"
  enable_key_rotation     = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false

  tags = {
    "Description" = "EKS Cluster Control Plane Logs Cloudwatch Log Group CMKMS"
    "Name"        = "cloudwatch/${local.cluster_log_group_name}"
  }
}

resource "aws_kms_alias" "cloudwatch" {
  name          = "alias/cloudwatch/${local.cluster_log_group_name}"
  target_key_id = aws_kms_key.cloudwatch.key_id
}

resource "aws_kms_key_policy" "cloudwatch" {
  key_id = aws_kms_key.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch_kms_permissions.json
}

data "aws_iam_policy_document" "cloudwatch_kms_permissions" {
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
    sid    = "Enable Cloudwatch Logs Encryption"

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
        "logs.${data.aws_region.current.region}.amazonaws.com",
      ]
    }

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:${local.cluster_log_group_name}",
      ]
    }
  }
}
