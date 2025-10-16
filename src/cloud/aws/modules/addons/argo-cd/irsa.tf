resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = local.irsa_name

  tags = {
    "Description" = "Argo-CD IRSA"
    "Name"        = local.irsa_name
  }
}

data "aws_iam_policy_document" "trust_relationships" {
  policy_id = "TrustRelationships"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "AllowOidcIrsaAssumeRole"

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_identity_issuer_url, "https://", "")}:aud"
      values = [
        "sts.amazonaws.com",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_identity_issuer_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.namespace}:${local.irsa_name}",
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

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_policy" "this" {
  name   = "${aws_iam_role.this.id}-permissions"
  policy = data.aws_iam_policy_document.permissions.json

  tags = {
    "Description" = "Argo-CD IRSA Permissions"
    "Name"        = "${aws_iam_role.this.id}-permissions"
  }
}

data "aws_iam_policy_document" "permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"

  statement {
    effect = "Allow"
    sid    = "AllowAbacGetSecretAndKms"

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
