variable "id_label" {
  description = "Consistent naming label as unique resource identifier"
  nullable    = false
  sensitive   = false
  type        = string
}

// -- EKS Cluster
variable "cluster_version" {
  description = "EKS Cluster Kubernetes version."
  nullable    = false
  sensitive   = false
  type        = string
}

// -- Networking
variable "private_subnet_ids" {
  description = "Private Subnet IDs from VPC Module"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public Subnet IDs from VPC Module"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "security_group_ids" {
  description = "All resources must be placed in the same VPC"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

// -- IAM
variable "ci_role_arn" {
  description = "GitLab CI dev-sec-ops Role ARN for CI Pipeline deployments"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "ci_role_name" {
  description = "GitLab CI Role name"
  nullable    = false
  sensitive   = false
  type        = string
}
