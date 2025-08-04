## -- General

variable "id_label" {
  description = "Consistent naming label as unique resource identifier"
  nullable    = false
  sensitive   = false
  type        = string
}

## -- Security

variable "sg_egress_rules" {
  description = "Map of maps with security group ingress rules"
  nullable    = false
  sensitive   = false
  type = map(
    object({
      cidr_ipv4   = string,
      description = string
      from_port   = number,
      ip_protocol = string,
      to_port     = number
    })
  )
}

variable "sg_ingress_rules" {
  description = "Map of maps with security group ingress rules"
  nullable    = false
  sensitive   = false
  type = map(
    object({
      cidr_ipv4   = string,
      description = string
      from_port   = number,
      ip_protocol = string,
      to_port     = number
    })
  )
}

## -- Subnets

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDR values"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDR values"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

## -- VPC

variable "vpc_cidr" {
  description = "CIDR Block for the VPC"
  nullable    = false
  sensitive   = false
  type        = string
}
