// ref:https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md
resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = local.irsa_name

  tags = {
    "Description" = "External DNS k8s extension IRSA"
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
      identifiers = [
        var.oidc_provider_arn
      ]
      type = "Federated"
    }

  }
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_policy" "this" {
  name   = "${aws_iam_role.this.name}-policy"
  policy = data.aws_iam_policy_document.permissions.json

  tags = {
    "Description"  = "External DNS k8s extension IRSA permissions policy"
    "ChartVersion" = var.chart_version
    "Name"         = "${aws_iam_role.this.name}-policy"
  }
}

data "aws_iam_policy_document" "permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableWriteRoute53"

    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    sid    = "EnableReadRoute53"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
    ]

    resources = [
      "*"
    ]
  }
}
