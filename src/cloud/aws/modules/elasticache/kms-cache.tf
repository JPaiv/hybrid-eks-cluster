resource "aws_kms_key" "cache" {
  deletion_window_in_days = 7
  description             = "CM KMS key"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.cache.json

  tags = {
    "Name"        = "cache/${local.id_label}"
    "Description" = "CM KMS key"
  }
}

resource "aws_kms_alias" "cache" {
  name          = "alias/cache/${local.id_label}"
  target_key_id = aws_kms_key.cache.key_id
}

data "aws_iam_policy_document" "cache" {
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
}
