resource "aws_security_group" "this" {
  description = "Allow traffic only to and from the EKS Worker Nodes"
  name        = local.id_label
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow inbound traffic only from the EKS Worker Nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.security_group_ids
  }

  egress {
    description     = "Allow outbound traffic only to the EKS Worker Nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.security_group_ids
  }

  tags = {
    "Description" = "Allow traffic only to and from the EKS Worker Nodes"
    "Name"        = local.id_label
  }
}
