# ---------------------------------------------------------------------------------------------------------------------
# VPC PRIVATE AND PUBLIC SUBNETS
# Create one public and one private subnet in each availability zone of the AWS region
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  availability_zone       = element(data.aws_availability_zones.current.names, count.index)
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.this.id

  tags = {
    "Description"                           = "Public Subnet ${tostring(count.index)} in the VPC ${var.id_label} for the internet-facing resources (e.g., ALB)"
    "Name"                                  = "${var.id_label}-subnet-public-${tostring(count.index)}"
    "kubernetes.io/cluster/${var.id_label}" = "owned" # Discovery tag for the AWS Load Balancer Controller and Karpenter
    "kubernetes.io/role/elb"                = 1       # Discovery tag for the AWS Load Balancer Controller
  }
}

resource "aws_route_table" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    "Description" = "Route Table for the Public Subnets in the VPC ${var.id_label}, routing 0.0.0.0/0 to the Internet Gateway"
    "Name"        = "${var.id_label}-public-subnet-rt-${tostring(count.index)}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

# ---------------------------------------------------------------------------------------------------------------------
# PRIVATE SUBNETS
# Private subnets have Karpenter and AWS Load Balancer Controller discovery tags
# Route private subnets through the NAT Gateways, each with their own unique persistent Elastic IP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "private" {
  count = length(var.public_subnet_cidrs)

  availability_zone = element(data.aws_availability_zones.current.names, count.index)
  cidr_block        = var.private_subnet_cidrs[count.index]
  vpc_id            = aws_vpc.this.id

  tags = {
    "Description"                           = "Private subnet ${tostring(count.index)} in the VPC ${var.id_label} for resources without direct internet access"
    "Name"                                  = "${var.id_label}-subnet-private-${tostring(count.index)}"
    "karpenter.sh/discovery"                = var.id_label # Discovery tag for Karpenter
    "kubernetes.io/cluster/${var.id_label}" = "owned"      # Discovery tag for AWS Load Balancer Controller and Karpenter
    "kubernetes.io/role/internal-elb"       = 1            # Discovery tag for AWS Load Balancer Controller
  }
}

resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_cidrs)

  domain = "vpc"

  tags = {
    "Description" = "Elastic IP for NAT Gateway in the VPC (${var.id_label}) Public Subnet ${tostring(count.index)}, providing outbound internet access for private subnets"
    "Name"        = "${var.id_label}-nat-gw-eip-${tostring(count.index)}"
  }
}

resource "aws_nat_gateway" "this" {
  count = length(var.public_subnet_cidrs)

  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    "Description" = "NAT Gateway ${tostring(count.index)} in the Public Subnet ${tostring(count.index)}, allowing private subnets in VPC ${var.id_label} to access the internet"
    "Name"        = "${var.id_label}-nat-gw-${tostring(count.index)}"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this.*.id, count.index)
  }

  tags = {
    "Description" = "Route table for the Private Subnet ${tostring(count.index)} in the VPC ${var.id_label}, routing 0.0.0.0/0 through NAT Gateway"
    "Name"        = "${var.id_label}-nat-gw-rt-${tostring(count.index)}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}
