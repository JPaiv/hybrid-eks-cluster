# ---------------------------------------------------------------------------------------------------------------------
# CUSTOMER MANAGED ENCRYPTION KEY
# Unique KMS key for the secret encryption
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "this" {
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    var.abac_tags,
    {
      "Description" = var.description
      "Name"        = "secret/${var.vault_name}"
    }
  )
}

resource "aws_kms_alias" "this" {
  name          = "alias/secret/${var.vault_name}"
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
}
