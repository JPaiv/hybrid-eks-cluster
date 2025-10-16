# ---------------------------------------------------------------------------------------------------------------------
# ENCRYPT VPC IP TRAFFIC FLOW LOGS S3 BUCKET
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "this" {
  for_each = var.loki_buckets

  deletion_window_in_days = 7
  description             = "Loki log storage"
  enable_key_rotation     = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false

  tags = {
    "Description" = "Loki log storage"
    "Name"        = "s3/${aws_s3_bucket.this[each.key].id}"
  }
}

resource "aws_kms_alias" "this" {
  for_each = var.loki_buckets

  name          = "alias/s3/${aws_s3_bucket.this[each.key].id}"
  target_key_id = aws_kms_key.this[each.key].key_id
}

resource "aws_kms_key_policy" "this" {
  for_each = var.loki_buckets

  key_id = aws_kms_key.this[each.key].id
  policy = data.aws_iam_policy_document.kms_permissions.json
}

data "aws_iam_policy_document" "kms_permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"

  statement {
    effect = "Allow"
    sid    = "Allow IAM root User"

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
