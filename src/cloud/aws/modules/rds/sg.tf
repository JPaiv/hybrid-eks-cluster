resource "aws_security_group" "this" {
  description = "Allow traffic only to and from the EKS Worker Nodes"
  name        = "${local.name_label}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow inbound traffic only from the EKS Worker Nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
  }

  egress {
    description     = "Allow outbound traffic only to the EKS Worker Nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
  }

  tags = {
    "Description" = "Allow traffic only to and from the EKS Worker Nodes"
    "Name"        = "${local.name_label}-sg"
  }
}
