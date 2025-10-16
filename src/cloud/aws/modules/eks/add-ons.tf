# ---------------------------------------------------------------------------------------------------------------------
# AWS MANAGED ADDONS
# CoreDNS for pods and services DNS resolution
# EBS for persistent volumes for pods
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_eks_addon" "coredns" {
  addon_name                  = "coredns"
  addon_version               = "v1.12.4-eksbuild.1"
  cluster_name                = aws_eks_cluster.this.name
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
    ]
  })

  tags = {
    "Description" = "AWS-managed CoreDNS add-on providing DNS resolution for all pods and services"
    "Name"        = "${aws_eks_cluster.this.name}-core-dns"
  }
}

resource "aws_eks_addon" "metrics" {
  addon_name                  = "metrics-server"
  addon_version               = "v0.8.0-eksbuild.2"
  cluster_name                = aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  configuration_values = jsonencode({
    tolerations = [
      {
        key      = "CriticalAddonsOnly"
        operator = "Exists"
      },
    ]
  })

  tags = {
    "Description" = "AWS-managed CoreDNS add-on providing DNS resolution for all pods and services"
    "Name"        = "${aws_eks_cluster.this.name}-metrics-server"
  }
}

resource "aws_eks_addon" "ebs" {
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.50.1-eksbuild.1"
  cluster_name                = aws_eks_cluster.this.id
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = aws_iam_role.ebs.arn

  tags = {
    "Description" = "AWS-managed EBS CSI Driver add-on enabling dynamic provisioning and management of EBS Persistent Volumes for pods"
    "Name"        = "${aws_eks_cluster.this.name}-ebs-csi"
  }
}
