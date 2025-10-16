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
