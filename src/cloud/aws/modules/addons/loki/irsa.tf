# ---------------------------------------------------------------------------------------------------------------------
# LOKI IRSA
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = local.irsa_name

  tags = {
    "Description" = "Loki IRSA"
    "Name"        = local.irsa_name
  }
}

data "aws_iam_policy_document" "trust_relationships" {
  policy_id = "IrsaTrustPolicy"
  version   = "2012-10-17"

  statement {
    effect = "Allow"
    sid    = "AllowOidcIrsaAssumeRole"

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringLike"
      variable = "${replace("${var.oidc_identity_issuer_url}", "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.namespace}:${local.irsa_name}",
      ]
    }

    condition {
      test     = "StringLike"
      variable = "${replace("${var.oidc_identity_issuer_url}", "https://", "")}:aud"
      values = [
        "sts.amazonaws.com",
      ]
    }

    principals {
      type = "Federated"
      identifiers = [
        var.oidc_provider_arn,
      ]
    }
  }
}

resource "aws_iam_policy" "this" {
  description = "Loki IRSA Permissions"
  name        = "${aws_iam_role.this.name}-permissions"
  policy      = data.aws_iam_policy_document.this.json

  tags = {
    "Description" = "Loki IRSA Permissions"
    "Name"        = "${aws_iam_role.this.name}-permissions"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

locals {
  s3_bucket_arns = flatten([
    for bucket in aws_s3_bucket.this : [
      bucket.arn,
      "${bucket.arn}/*"
    ]
  ])
}

data "aws_iam_policy_document" "this" {
  policy_id = "Permissions"
  version   = "2012-10-17"

  statement {
    effect = "Allow"
    sid    = "AllowS3ReadWriteDelete"

    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = local.s3_bucket_arns
  }

  statement {
    effect = "Allow"
    sid    = "AllowKmsEncryptDecrypt"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]

    resources = [for k in aws_kms_key.this : k.arn]
  }

  statement {
    effect = "Allow"
    sid    = "AllowAbacExternalSecret"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:ReEncrypt*",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
    ]

    resources = [
      "*",
    ]

    dynamic "condition" {
      for_each = var.abac_tags
      content {
        test     = "StringEquals"
        variable = "aws:${condition.value["tag_type"]}/${condition.value["abac_key"]}"
        values   = condition.value["abac_values"]
      }
    }
  }
}
