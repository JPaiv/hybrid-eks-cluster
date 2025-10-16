# ---------------------------------------------------------------------------------------------------------------------
# EKS CLUSTER EC2 NODES ROLE
# Used by the both Managed Node Group and Karpenter
# ref: https://docs.aws.amazon.com/eks/latest/userguide/node-iam-role.html
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "node" {
  assume_role_policy = data.aws_iam_policy_document.node_trust_relationships.json
  name               = "${var.id_label}-eks-node-role"

  tags = {
    "Description" = "EKS EC2 Nodes Role"
    "Name"        = "${var.id_label}-eks-node-role"
  }
}

data "aws_iam_policy_document" "node_trust_relationships" {
  policy_id = "TrustRelationships"
  version   = "2012-10-17"

  statement {
    effect = "Allow"
    sid    = "AllowServiceAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CUSTOM PERMISSIONS POLICY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "node" {
  name   = "${aws_iam_role.node.id}-policy"
  policy = data.aws_iam_policy_document.node_permissions.json

  tags = {
    "Description" = "EKS EC2 Worker Nodes Role Permissions"
    "Name"        = "${aws_iam_role.node.id}-policy"
  }
}

resource "aws_iam_role_policy_attachment" "node_permissions" {
  policy_arn = aws_iam_policy.node.arn
  role       = aws_iam_role.node.name
}

data "aws_iam_policy_document" "node_permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableEc2Tags"

    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"
    sid    = "EnableEc2Networking"

    actions = [
      "ec2:AssignPrivateIpAddresses",
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstan§nterfaces",
      "ec2:DescribeTags",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:UnassignPrivateIpAddresses",
    ]

    resources = [
      "*"
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS MANAGED POLICIES
# ---------------------------------------------------------------------------------------------------------------------

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSClusterPolicy.html
resource "aws_iam_role_policy_attachment" "nodeAmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSWorkerNodePolicy.html
resource "aws_iam_role_policy_attachment" "nodeAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKS_CNI_Policy.html
resource "aws_iam_role_policy_attachment" "nodeAmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonSSMManagedInstanceCore.html
resource "aws_iam_role_policy_attachment" "nodeAmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.node.name
}

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEBSCSIDriverPolicy.html
resource "aws_iam_role_policy_attachment" "nodeAmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.node.name
}

# ref: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html
resource "aws_iam_instance_profile" "node" {
  name = "${aws_iam_role.node.name}-instance-profile"
  role = aws_iam_role.node.name
}
