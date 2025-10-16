# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# VPC values from the VPC module
# -> modules/vpc
# ---------------------------------------------------------------------------------------------------------------------

variable "id_label" {
  description = "A unique, consistent label used to identify resources across the infrastructure."
  type        = string
  nullable    = false
  sensitive   = false
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  nullable    = false
  sensitive   = false
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs from the VPC module."
  type        = list(string)
  nullable    = false
  sensitive   = false
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs from the VPC module."
  type        = list(string)
  nullable    = false
  sensitive   = false
}
