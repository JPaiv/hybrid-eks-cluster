# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "id_label" {
  description = "Unique resource identifier derived from the naming label module"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "sg_egress_rules" {
  description = "Security group ingress (inbound) traffic rules"
  nullable    = false
  sensitive   = false
  type = map(
    object({
      cidr_ipv4   = string,
      description = string
      from_port   = number,
      ip_protocol = string,
      name        = string,
      to_port     = number,
    })
  )
}

variable "sg_ingress_rules" {
  description = "Security group egress (outbound) traffic rules"
  nullable    = false
  sensitive   = false
  type = map(
    object({
      cidr_ipv4   = string,
      description = string
      from_port   = number,
      ip_protocol = string,
      name        = string,
      to_port     = number,
    })
  )
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets within the VPC"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets within the VPC"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "s3_force_destroy" {
  default     = true
  description = "Destroy the S3 bucket even if it has objects"
  nullable    = false
  sensitive   = false
  type        = bool
}
