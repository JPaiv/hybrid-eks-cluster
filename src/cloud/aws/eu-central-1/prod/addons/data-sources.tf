data "aws_region" "current" {}

data "aws_ssm_parameter" "cluster" {
  name = var.cluster_id
}

data "aws_ssm_parameter" "vpc" {
  name = var.cluster_id
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_id
}
