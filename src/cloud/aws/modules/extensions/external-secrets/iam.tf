// -- Create an IRSA fo the external-secrets
// ref: https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html
resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = local.irsa_name

  tags = {
    "Description" = "Extension External Secrets IRSA"
    "Name"        = local.irsa_name
  }
}

data "aws_iam_policy_document" "trust_relationships" {
  policy_id = "trust-relationships"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableIrsa"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_identity_issuer_url, "https://", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_identity_issuer_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.namespace}:${local.irsa_name}"
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
  name   = "${aws_iam_role.this.name}-policy"
  policy = data.aws_iam_policy_document.permissions.json

  tags = {
    "Description" = "Extension External-Secrets IRSA Permissions Policy"
    "Name"        = "${aws_iam_role.this.name}-policy"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy_document" "permissions" {
  policy_id = "permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableReadSecrets"

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
    ]

    resources = [
      "*",
    ]
  }
}
