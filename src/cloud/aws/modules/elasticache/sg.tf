# ---------------------------------------------------------------------------------------------------------------------
# ELASTICACHE SECURITY GROUP
# Firewall rules
# Only allow secure traffic to and from the EKS worker nodes
# Use pet name, beause the SG updating is artbitrary
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "this" {
  description = "Allow traffic to and from the EKS worker nodes"
  name        = "${local.id_label}-sg"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Redis traffic from the EKS worker nodes"
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id] # Source
  }

  egress {
    description     = "Allow Redis traffic to the EKS worker nodes"
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [data.aws_eks_cluster.this.vpc_config[0].cluster_security_group_id] # Destination
  }

  tags = {
    "Description" = "Allow traffic to and from the EKS worker nodes"
    "Name"        = "${local.id_label}-sg"
  }
}
