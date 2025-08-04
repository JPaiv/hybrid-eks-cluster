resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Description" = "VPC for environment ${var.id_label}"
    "Name"        = "${var.id_label}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    "Description" = "Internet Gateway to connect the VPC to the Internet"
    "Name"        = "${var.id_label}-vpc-gw"
  }
}

resource "aws_route_table" "vpc_gw" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    "Description" = "Route VPC traffic trough the Internet Gateway"
    "Name"        = "${var.id_label}-vpc-gw-rt"
  }
}
