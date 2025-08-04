resource "aws_kms_key" "ssm" {
  description = "VPC ${var.id_label} parameters KMS CM"

  // -- Lifecycle
  deletion_window_in_days = 7
  enable_key_rotation     = true

  // -- Usage
  key_usage    = "ENCRYPT_DECRYPT"
  multi_region = false

  tags = {
    "Description" = "VPC ${var.id_label} parameters KMS CM"
    "Name"        = "ssm/vpc/${var.id_label}"
  }
}

resource "aws_kms_alias" "ssm" {
  name          = "alias/ssm/vpc/${var.id_label}"
  target_key_id = aws_kms_key.ssm.key_id
}

resource "aws_kms_key_policy" "ssm" {
  key_id = aws_kms_key.ssm.id
  policy = data.aws_iam_policy_document.ssm_kms_permissions.json
}

data "aws_iam_policy_document" "ssm_kms_permissions" {
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
}
