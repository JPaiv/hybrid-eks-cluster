resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  availability_zone       = element(data.aws_availability_zones.this.names, count.index)
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.this.id

  tags = {
    "Description"                           = "${var.id_label} public subnet ${tostring(count.index)}"
    "Name"                                  = "${var.id_label}-publ-subn-${tostring(count.index)}"
    "kubernetes.io/cluster/${var.id_label}" = "owned" // -- Discovery tag for the AWS Load Balancer Controller and Karpenter
    "kubernetes.io/role/elb"                = 1       // -- Discovery tag for the AWS Load Balancer Controller
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
    "Description" = "Route Table to connect Public Subnets to the Internet trough the VPC Internet Gateway"
    "Name"        = "${var.id_label}-igw-rt-${tostring(count.index)}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

resource "aws_subnet" "private" {
  count = length(var.public_subnet_cidrs)

  availability_zone = element(data.aws_availability_zones.this.names, count.index)
  cidr_block        = var.private_subnet_cidrs[count.index]
  vpc_id            = aws_vpc.this.id

  tags = {
    "Description"                           = "${var.id_label} private subnet ${tostring(count.index)}"
    "Name"                                  = "${var.id_label}-priv-subn-${tostring(count.index)}"
    "karpenter.sh/discovery"                = var.id_label // -- Discovery tag for Karpenter
    "kubernetes.io/cluster/${var.id_label}" = "owned"      // -- Discovery tag for the AWS Load Balancer Controller and Karpenter
    "kubernetes.io/role/internal-elb"       = 1            // -- Discovery tag for the AWS Load Balancer Controller
  }
}

resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_cidrs)

  domain = "vpc"

  tags = {
    "Description" = "Elastic-IP ${tostring(count.index)} for NAT Gateway"
    "Name"        = "${var.id_label}-nat-gw-eip-${tostring(count.index)}"
  }
}

resource "aws_nat_gateway" "this" {
  count = length(var.public_subnet_cidrs)

  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    "Description" = "NAT Gateway to connect a Private Subnet to the Internet"
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
    "Description" = "Route Private Subnet traffic trough a NAT Gateway"
    "Name"        = "${var.id_label}-nat-gw-${tostring(count.index)}-rt-${tostring(count.index)}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.public_subnet_cidrs)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}
