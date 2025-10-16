# ---------------------------------------------------------------------------------------------------------------------
# API-ONLY AUTHENTICATION
# Only allow API authentication
# ConfigMap is disabled
# ref: https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
# ref: https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_eks_access_entry" "jpaiv" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/juho.paivarinta@unikie.com"
  type          = "STANDARD"

  kubernetes_groups = [
    "admin",
    "cluster-admin",
    "edit",
    "secrets",
    "view",
  ]

  tags = {
    "Description" = "Unikie Admin User"
    "Name"        = "juho.paivarinta@unikie.com"
  }
}

resource "aws_eks_access_policy_association" "jpaiv" {
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/juho.paivarinta@unikie.com"

  access_scope {
    type = "cluster"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GITLAB
# WIP
# CURRENTLY IN TESTING
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_eks_access_entry" "gitlab" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ums-ec1-prod-core-gitlab-oidc-dev-sec-ops"
  type          = "STANDARD"

  kubernetes_groups = [
    "edit",
    "secrets",
    "view",
  ]

  tags = {
    "Description" = "GitLab CI deployment role"
    "Name"        = "ums-ec1-prod-core-gitlab-oidc-dev-sec-ops"
  }
}

resource "aws_eks_access_policy_association" "gitlab" {
  cluster_name  = aws_eks_cluster.this.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ums-ec1-prod-core-gitlab-oidc-dev-sec-ops"

  access_scope {
    type = "cluster"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# NODE ROLE
# Enable EKS Cluster Node Role to access the EKS Cluster
# Required by the Managed Node Group and Karpenter
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_eks_access_entry" "node" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = aws_iam_role.node.arn
  type          = "EC2_LINUX" # Linux covers Bottlerocket as well

  tags = {
    "Description" = "EC2 Worker Node Role"
    "Name"        = "${aws_eks_cluster.this.name}-${aws_iam_role.node.name}"
  }
}
