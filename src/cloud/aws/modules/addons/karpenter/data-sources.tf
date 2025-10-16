# Default: eu-central-1
data "aws_region" "current" {}

# Account ID
data "aws_caller_identity" "current" {}

# Default: aws
data "aws_partition" "current" {}

# EKS Cluster attributes
data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}
