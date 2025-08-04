// -- Allow HTTPS-only ingress traffic and all eggress traffic
resource "aws_security_group" "this" {
  description = "Allow HTTPS only ingress and secure egress traffic"
  name        = "${var.id_label}-sg"
  vpc_id      = aws_vpc.this.id

  lifecycle {
    create_before_destroy = false
  }

  tags = {
    "Description"                           = "Allow HTTPS only public ingress and all egress"
    "Name"                                  = "${var.id_label}-sg"
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
    "Description" = "Allow only secure ingress inbound traffic"
    "Name"        = "${var.id_label}-secure-ingress"
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
    "Description" = "Allow all outgoing traffic"
    "Name"        = "${var.id_label}-all-egress"
  }
}
