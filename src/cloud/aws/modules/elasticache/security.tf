resource "aws_security_group" "this" {
  name        = "${local.id_label}-sg"
  description = "Allow Redis traffic from the EKS cluster"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Redis traffic from EKS worker nodes"
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [var.eks_sg_id] // -- Source
  }

  egress {
    description     = "Allow Redis traffic to EKS worker nodes"
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [var.eks_sg_id] // -- Destination
  }

  tags = {
    "Description" = "Allow Redis traffic from the EKS cluster"
    "Name"        = "${local.id_label}-sg"
  }
}
