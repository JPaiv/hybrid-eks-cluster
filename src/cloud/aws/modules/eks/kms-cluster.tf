resource "aws_kms_key" "cluster" {
  // -- General
  description = "Control Plane Secrets KMS CM Key"

  // -- Lifecycle
  deletion_window_in_days = 30
  enable_key_rotation     = true

  // -- Usage
  key_usage    = "ENCRYPT_DECRYPT"
  multi_region = false

  tags = {
    "Description" = "Control Plane Secrets KMS CM Key"
    "Name"        = "eks/${var.id_label}"
  }
}

resource "aws_kms_alias" "cluster" {
  name          = "alias/eks/${var.id_label}"
  target_key_id = aws_kms_key.cluster.key_id
}

resource "aws_kms_key_policy" "cluster" {
  key_id = aws_kms_key.cluster.id
  policy = data.aws_iam_policy_document.cluster_kms_permissions.json
}

data "aws_iam_policy_document" "cluster_kms_permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "Enable IAM Root Permissions"

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
