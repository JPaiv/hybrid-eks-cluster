// -- Karpenter Controller
// ref: https://karpenter.sh/preview/getting-started/migrating-from-cas/#create-iam-roles
resource "aws_iam_role" "irsa" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = local.irsa_name

  tags = {
    "Description" = "EKS Cluster ${var.cluster_id} Karpenter Controller IRSA"
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
        var.oidc_provider_arn
      ]
    }
  }
}

resource "aws_iam_policy" "irsa" {
  name   = "${aws_iam_role.irsa.name}-policy"
  policy = data.aws_iam_policy_document.permissions.json

  tags = {
    "Description" = "Karpenter Controller IRSA permissions policy"
    "Name"        = "${aws_iam_role.irsa.name}-policy"
  }
}

resource "aws_iam_role_policy_attachment" "irsa" {
  policy_arn = aws_iam_policy.irsa.arn
  role       = aws_iam_role.irsa.name
}
