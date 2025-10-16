# ---------------------------------------------------------------------------------------------------------------------
# HTTPS AND SSH ONLY INGRESSAAND ALL EGRESS PUBLIC TRAFFIC
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "this" {
  description = "Security group for the VPC ${var.id_label}, HTTPS inbound, SSH admin access, and secure egress traffic"
  name        = var.id_label
  vpc_id      = aws_vpc.this.id

  lifecycle {
    create_before_destroy = false
  }

  tags = {
    "Description"                           = "Security group for the VPC ${var.id_label}, HTTPS inbound, SSH admin access, and secure egress traffic"
    "Name"                                  = var.id_label
    "kubernetes.io/cluster/${var.id_label}" = "owned"
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.sg_ingress_rules

  cidr_ipv4         = each.value.cidr_ipv4
  description       = each.value.description
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  security_group_id = aws_security_group.this.id
  to_port           = each.value.to_port

  lifecycle {
    create_before_destroy = false
  }

  tags = {
    "Description" = each.value.description
    "Name"        = each.value.name
  }
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.sg_egress_rules

  cidr_ipv4         = each.value.cidr_ipv4
  description       = each.value.description
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  security_group_id = aws_security_group.this.id
  to_port           = each.value.to_port

  lifecycle {
    create_before_destroy = false
  }

  tags = {
    "Description" = each.value.description
    "Name"        = each.value.name
  }
}
