resource "aws_kms_key" "this" {
  deletion_window_in_days = 30
  description             = "RDS Postgresql instance ${local.name_label}"
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.this.json

  tags = {
    "Description" = "RDS Postgresql instance ${local.name_label}"
    "Name"        = "rds/${local.name_label}"
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/rds/${local.name_label}"
  target_key_id = aws_kms_key.this.key_id
}

data "aws_iam_policy_document" "this" {
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
