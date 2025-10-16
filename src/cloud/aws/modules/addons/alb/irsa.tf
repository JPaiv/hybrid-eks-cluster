# ---------------------------------------------------------------------------------------------------------------------
# AWS LB CONTROLLER IRSA
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = local.irsa_name

  tags = {
    "Description" = "AWS Load Balancer Controller IRSA"
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

# ---------------------------------------------------------------------------------------------------------------------
# CUSTOM PERMISSIONS POLICY
# ref: curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.2/docs/install/iam_policy.json
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "this" {
  name   = "${aws_iam_role.this.name}-permissions"
  policy = data.aws_iam_policy_document.permissions.json

  tags = {
    "Description" = "AWS Load Balancer Controller IRSA Permissions"
    "Name"        = "${aws_iam_role.this.name}-permissions"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy_document" "permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"

  statement {
    effect = "Allow"
    sid    = "CreateServiceLinkedRoleForELB"

    actions = [
      "iam:CreateServiceLinkedRole",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values = [
        "elasticloadbalancing.amazonaws.com",
      ]
    }
  }

  statement {
    effect = "Allow"
    sid    = "DescribeEc2AndElbNetworkingResources"

    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeCoipPools",
      "ec2:DescribeInstances",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcPeeringConnections",
      "ec2:DescribeVpcs",
      "ec2:GetCoipPoolUsage",
      "elasticloadbalancing:DescribeListenerAttributes",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeTrustStores",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"
    sid    = "AllowWAFShieldACMOperations"

    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "cognito-idp:DescribeUserPoolClient",
      "iam:GetServerCertificate",
      "iam:ListServerCertificates",
      "shield:CreateProtection",
      "shield:DeleteProtection",
      "shield:DescribeProtection",
      "shield:GetSubscriptionState",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
      "waf-regional:GetWebACL",
      "waf-regional:GetWebACLForResource",
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL",
      "wafv2:GetWebACL",
      "wafv2:GetWebACLForResource",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AuthorizeRevokeSGIngress"
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CreateSecurityGroup"
    effect = "Allow"

    actions = [
      "ec2:CreateSecurityGroup",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "TagNewSecurityGroup"
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:*:*:security-group/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateSecurityGroup"]
    }

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    effect = "Allow"
    sid    = "ManageSecurityGroupTags"

    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]

    resources = [
      "arn:aws:ec2:*:*:security-group/*",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["true"]
    }

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = "ManageTaggedSecurityGroups"
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = ["*"]

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = "CreateELBAndTargetGroup"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
    ]

    resources = ["*"]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = "ManageListenersAndRules"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteRule",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"
    sid    = "ManageELBTagsOnLoadBalancers"

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
    ]

    resources = [
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["true"]
    }

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    effect = "Allow"
    sid    = "ManageELBTagsOnListenersAndRules"

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
    ]

    resources = [
      "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
    ]
  }

  statement {
    sid    = "ModifyELBAndTargetGroupAttributes"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:ModifyListenerAttributes",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
    ]

    resources = ["*"]

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = "AddTagsOnCreateELBOrTargetGroup"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:AddTags",
    ]

    resources = [
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "elasticloadbalancing:CreateAction"
      values = [
        "CreateLoadBalancer",
        "CreateTargetGroup",
      ]
    }

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = "RegisterAndDeregisterTargets"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:RegisterTargets",
    ]

    resources = [
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
    ]
  }

  statement {
    sid    = "ModifyListenerAndRules"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:SetWebAcl",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ManageRoute53Records"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }

  statement {
    sid    = "ListRoute53HostedZonesAndRecords"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
    ]

    resources = ["*"]
  }
}
