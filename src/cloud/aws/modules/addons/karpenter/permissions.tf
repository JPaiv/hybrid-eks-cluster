# ---------------------------------------------------------------------------------------------------------------------
# KARPENTER CONTROLLER IRSA PERMISSIONS POLICY
# Custom IAM Policy from the Karpenter developers
# Karpenter version v.1+
# ref: https://karpenter.sh/docs/reference/cloudformation/
# -> Meant for cloudformation, but no better docs are available
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "permissions" {
  policy_id = "KarpenterControllerPermissions"
  version   = "2012-10-17"
  statement {
    sid    = "AllowScopedEC2InstanceAccessActions"
    effect = "Allow"

    resources = [
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}::image/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}::snapshot/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:security-group/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:subnet/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:capacity-reservation/*",
    ]

    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
    ]
  }

  statement {
    sid       = "AllowScopedEC2LaunchTemplateAccessActions"
    effect    = "Allow"
    resources = ["arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:launch-template/*"]

    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.sh/nodepool"
      values   = ["*"]
    }
  }

  statement {
    sid    = "AllowScopedEC2InstanceActionsWithTags"
    effect = "Allow"

    resources = [
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:fleet/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:instance/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:volume/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:network-interface/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:launch-template/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:spot-instances-request/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:capacity-reservation/*",
    ]

    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
      "ec2:CreateLaunchTemplate",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = [var.cluster_id]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${var.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.sh/nodepool"
      values   = ["*"]
    }
  }

  statement {
    sid    = "AllowScopedResourceCreationTagging"
    effect = "Allow"

    resources = [
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:fleet/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:instance/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:volume/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:network-interface/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:launch-template/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:spot-instances-request/*",
    ]

    actions = ["ec2:CreateTags"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.sh/nodepool"
      values   = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${var.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = [var.cluster_id]
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"

      values = [
        "RunInstances",
        "CreateFleet",
        "CreateLaunchTemplate",
      ]
    }
  }

  statement {
    sid       = "AllowScopedResourceTagging"
    effect    = "Allow"
    resources = ["arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:instance/*"]
    actions   = ["ec2:CreateTags"]

    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = [var.cluster_id]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.sh/nodepool"
      values   = ["*"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"

      values = [
        "eks:eks-cluster-name",
        "karpenter.sh/nodeclaim",
        "Name",
      ]
    }
  }

  statement {
    sid    = "AllowScopedDeletion"
    effect = "Allow"

    resources = [
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:instance/*",
      "arn:${data.aws_partition.current.id}:ec2:${data.aws_region.current.region}:*:launch-template/*",
    ]

    actions = [
      "ec2:TerminateInstances",
      "ec2:DeleteLaunchTemplate",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.sh/nodepool"
      values   = ["*"]
    }
  }

  statement {
    sid       = "AllowRegionalReadActions"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeCapacityReservations",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [data.aws_region.current.region]
    }
  }

  statement {
    sid       = "AllowSSMReadActions"
    effect    = "Allow"
    resources = ["arn:${data.aws_partition.current.id}:ssm:${data.aws_region.current.region}::parameter/aws/service/*"]
    actions   = ["ssm:GetParameter"]
  }

  statement {
    sid       = "AllowPricingReadActions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["pricing:GetProducts"]
  }

  statement {
    sid       = "AllowInterruptionQueueActions"
    effect    = "Allow"
    resources = [aws_sqs_queue.this.arn]

    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
    ]
  }

  statement {
    sid       = "AllowPassingInstanceRole"
    effect    = "Allow"
    resources = [var.node_role_arn]
    actions   = ["iam:PassRole"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"

      values = [
        "ec2.amazonaws.com",
        "ec2.amazonaws.com.cn",
      ]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileCreationActions"
    effect    = "Allow"
    resources = ["arn:${data.aws_partition.current.id}:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*"]
    actions   = ["iam:CreateInstanceProfile"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = [data.aws_region.current.region]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${var.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = [var.cluster_id]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileTagActions"
    effect    = "Allow"
    resources = ["arn:${data.aws_partition.current.id}:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*"]
    actions   = ["iam:TagInstanceProfile"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = [data.aws_region.current.region]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${var.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = ["${var.cluster_id}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = ["${data.aws_region.current.region}"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileActions"
    effect    = "Allow"
    resources = ["arn:${data.aws_partition.current.id}:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*"]

    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:DeleteInstanceProfile",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = [data.aws_region.current.region]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }
  }

  statement {
    sid       = "AllowInstanceProfileReadActions"
    effect    = "Allow"
    resources = ["arn:${data.aws_partition.current.id}:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*"]
    actions   = ["iam:GetInstanceProfile"]
  }

  statement {
    sid       = "AllowUnscopedInstanceProfileListAction"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:ListInstanceProfiles"]
  }

  statement {
    sid       = "AllowAPIServerEndpointDiscovery"
    effect    = "Allow"
    resources = ["arn:${data.aws_partition.current.id}:eks:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_id}"]
    actions   = ["eks:DescribeCluster"]
  }
}
