# ---------------------------------------------------------------------------------------------------------------------
# LOKI IRSA
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = local.irsa_name

  tags = {
    "Description" = "Alloy IRSA"
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
  description = "Loki IRSA Permissions policy"
  name        = "${aws_iam_role.this.name}-policy"
  policy      = data.aws_iam_policy_document.this.json

  tags = {
    "Description" = "Alloy IRSA Permission"
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
