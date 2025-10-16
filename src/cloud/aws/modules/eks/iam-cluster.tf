# ---------------------------------------------------------------------------------------------------------------------
# EKS CLUSTER CONTROL PLANE
# ---------------------------------------------------------------------------------------------------------------------

# ref: https://docs.aws.amazon.com/eks/latest/userguide/cluster-iam-role.html
resource "aws_iam_role" "cluster" {
  assume_role_policy = data.aws_iam_policy_document.cluster_trust_relationships.json
  name               = "${var.id_label}-eks-cluster-role"

  tags = {
    "Description" = "EKS Cluster Role"
    "Name"        = "${var.id_label}-eks-cluster-role"
  }
}

data "aws_iam_policy_document" "cluster_trust_relationships" {
  policy_id = "ServiceTrustPolicy"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "AllowEksService"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "eks.amazonaws.com",
      ]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS MANAGED PERMISSIONS POLICIES
# ---------------------------------------------------------------------------------------------------------------------

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSClusterPolicy.html
resource "aws_iam_role_policy_attachment" "clusterAmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSServicePolicy.html
resource "aws_iam_role_policy_attachment" "clusterAmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEKSVPCResourceController.html
resource "aws_iam_role_policy_attachment" "clusterAmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/CloudWatchFullAccess.html
resource "aws_iam_role_policy_attachment" "clusterCloudWatchFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.cluster.name
}
