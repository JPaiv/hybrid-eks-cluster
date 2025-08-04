resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = local.irsa_name

  tags = {
    "Description" = "EKS Cluster ${var.cluster_id} cilium-operator IRSA"
    "Name"        = local.irsa_name
  }
}

data "aws_iam_policy_document" "trust_relationships" {
  policy_id = "TrustRelationships"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableCiliumIrsa"

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
        "system:serviceaccount:${var.namespace}:cilium-operator"
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

// ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKS_CNI_Policy.html
resource "aws_iam_role_policy_attachment" "eks_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_policy" "permissions" {
  name   = "${aws_iam_role.this.name}-policy"
  policy = data.aws_iam_policy_document.permissions.json

  tags = {
    "Description" = "Service account cilium-operator IRSA Permissions Policy"
    "Name"        = "${aws_iam_role.this.name}-policy"
  }
}

resource "aws_iam_role_policy_attachment" "permissions" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.permissions.arn
}

// -- These permission are required but missing from the AWS managed AmazonEKS_CNI_Policy
data "aws_iam_policy_document" "permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableCiliumNetworking"

    actions = [
      "ec2:AssignPrivateIpAddresses",
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:CreateTags",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:UnassignPrivateIpAddresses",
    ]

    resources = [
      "*",
    ]
  }
}
