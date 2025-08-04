output "private_subnet_cidrs" {
  description = "AWS VPC Private Subnets CIDR Blocks"
  value       = var.private_subnet_cidrs
}

output "private_subnet_ids" {
  description = "AWS VPC Private Subnets ID's"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "AWS VPC Public Subnets CIDR Blocks"
  value       = var.public_subnet_cidrs
}

output "public_subnet_ids" {
  description = "AWS VPC Public Subnets ID's"
  value       = aws_subnet.public.*.id
}

output "security_group_ids" {
  description = "AWS VPC Security Group ID"
  value       = [aws_security_group.this.id]
}

output "vpc_id" {
  description = "AWS VPC ID"
  value       = aws_vpc.this.id
}
