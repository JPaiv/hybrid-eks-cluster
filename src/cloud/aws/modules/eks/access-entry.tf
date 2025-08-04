// -- Enable EKS Cluster Node Role to access the EKS Cluster
// -- Required by the Managed Node Group and Karpenter
resource "aws_eks_access_entry" "node" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = aws_iam_role.node.arn
  type          = "EC2_LINUX" // -- Linux covers Bottlerocket as well

  tags = {
    "Description" = "EKS Cluster ${aws_eks_cluster.this.name} EC2 Bottlerocket Node Role"
    "Name"        = "${aws_eks_cluster.this.name}-${aws_iam_role.node.name}"
  }
}

resource "aws_eks_access_entry" "hybrid" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = aws_iam_role.hybrid.arn
  type          = "HYBRID_LINUX"

  tags = {
    "Description" = "EKS Cluster ${aws_eks_cluster.this.name} EC2 Bottlerocket Node Role"
    "Name"        = "${aws_eks_cluster.this.name}-${aws_iam_role.node.name}"
  }
}
