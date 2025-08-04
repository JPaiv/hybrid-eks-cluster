variable "cluster_id" {
  description = "Default id(name) from the naming label module."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "priv_subnet_ids" {
  description = "EKS Cluster Private Subnets"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "security_group_ids" {
  description = "All EKS Cluster affiliated security groups"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "db_name" {
  nullable  = false
  sensitive = false
  type      = string
}

variable "db_username" {
  nullable  = false
  sensitive = false
  type      = string
}

variable "vpc_id" {
  nullable  = false
  sensitive = false
  type      = string
}

variable "deletion_protection" {
  default   = false
  nullable  = false
  sensitive = false
  type      = bool
}

variable "skip_final_snapshot" {
  default   = true
  nullable  = false
  sensitive = false
  type      = bool
}

variable "backup_retention_period" {
  default   = 14
  nullable  = false
  sensitive = false
  type      = number
}

variable "passw_secr_name" {
  description = "AWS Secret Manager secret name with the master password"
  nullable    = false
  sensitive   = true
  type        = string
}
