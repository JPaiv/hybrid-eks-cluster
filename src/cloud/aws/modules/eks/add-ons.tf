resource "aws_eks_addon" "coredns" {
  // -- General
  addon_name    = "coredns"
  addon_version = "v1.12.2-eksbuild.4"
  cluster_name  = aws_eks_cluster.this.name

  // -- Installation and Update
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  configuration_values = jsonencode({
    tolerations = [
      {
        key      = "CriticalAddonsOnly"
        operator = "Exists"
      },
      {
        key    = "node.cilium.io/agent-not-ready"
        value  = "true"
        effect = "NoExecute"
      },
      {
        key    = "coreAddonsOnly"
        value  = "true"
        effect = "NoExecute"
      }
    ]
  })

  tags = {
    "Description" = "DNS Server"
    "Name"        = "${aws_eks_cluster.this.name}-coredns"
  }
}

resource "aws_eks_addon" "ebs" {
  // -- General
  addon_name    = "aws-ebs-csi-driver"
  addon_version = "v1.46.0-eksbuild.1"
  cluster_name  = aws_eks_cluster.this.id

  // -- Installation and Update
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  // -- IRSA
  service_account_role_arn = aws_iam_role.ebs.arn

  tags = {
    "Description" = "Persistent Volume EBS CSI Driver"
    "Name"        = "${aws_eks_cluster.this.name}-ebs-csi-driver"
  }
}
