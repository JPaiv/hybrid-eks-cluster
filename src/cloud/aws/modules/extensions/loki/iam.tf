resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = local.irsa_name

  tags = {
    "Description" = "Loki ${local.id_label} IRSA"
    "Name"        = local.irsa_name
  }
}

data "aws_iam_policy_document" "trust_relationships" {
  policy_id = "TrustRelationships"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableIrsa"

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        var.oidc_provider_arn,
      ]
    }

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
  }
}

resource "aws_iam_policy" "this" {
  description = "Loki IRSA Permissions policy"
  name        = "${aws_iam_role.this.name}-policy"
  policy      = data.aws_iam_policy_document.this.json

  tags = {
    "Description" = "Loki IRSA Permissions Policy"
    "Name"        = "${aws_iam_role.this.name}-policy"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

data "aws_iam_policy_document" "this" {
  policy_id = "Permissions"
  version   = "2012-10-17"

  statement {
    effect = "Allow"
    sid    = "EnableS3ReadWrite"

    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListObjects",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_id_base}-*",
      "arn:aws:s3:::${local.bucket_id_base}-*/*"
    ]
  }

  statement {
    effect = "Allow"
    sid    = "EnableKmsReadWrite"

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      for key in aws_kms_key.loki_buckets : key.arn
    ]
  }

  statement {
    effect = "Allow"
    sid    = "EnableKmsList"

    actions = [
      "kms:ListKeys",
      "kms:ListAliases"
    ]

    resources = [
      "*",
    ]
  }
}
