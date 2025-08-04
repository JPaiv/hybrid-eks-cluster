# -- Create an instance profile for the Karpenter nodes
resource "aws_iam_instance_profile" "this" {
  name = "${var.cluster_id}-karpenter-node"
  role = var.node_role_name

  tags = {
    "Description"                              = "Karpanter Nodes Instance Profile"
    "Name"                                     = "${var.cluster_id}-karpenter-node"
    "karpenter.sh/discovery/${var.cluster_id}" = var.cluster_id
  }
}
