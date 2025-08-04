resource "aws_kms_key" "ebs" {
  description = "EBS Volumes Default KMS CM Key"

  // -- Lifecycle
  deletion_window_in_days = 7
  enable_key_rotation     = true

  // -- Usage
  key_usage    = "ENCRYPT_DECRYPT"
  multi_region = false

  tags = {
    "Description"                       = "EBS Volumes Default KMS CM Key"
    "Name"                              = "ebs/default"
    "Unikie:InfoSec:DataClassification" = "Extreme"
  }
}

resource "aws_kms_alias" "ebs" {
  name          = "alias/ebs/default"
  target_key_id = aws_kms_key.ebs.key_id
}

resource "aws_kms_key_policy" "ebs" {
  key_id = aws_kms_key.ebs.key_id
  policy = data.aws_iam_policy_document.ebs_permissions.json
}

data "aws_iam_policy_document" "ebs_permissions" {
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
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }

  statement {
    effect = "Allow"
    sid    = "Enable All Principals from EC2 Service"

    actions = [
      "kms:CreateGrant",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt",
    ]

    resources = [
      "*"
    ]

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
        "ec2.${data.aws_region.current.name}.amazonaws.com"
      ]
    }

    principals {
      type = "AWS"
      identifiers = [
        "*",
      ]
    }
  }
}
