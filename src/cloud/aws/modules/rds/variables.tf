variable "id_label" {
  description = "A unique identifier for the EKS cluster associated with this RDS instance. This is typically derived from a naming label module."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "priv_subnet_ids" {
  description = "A list of private subnet IDs where the RDS instance will be deployed. These subnets should be part of the EKS cluster's VPC and configured to prevent public access."
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "db_name" {
  description = "The name for the database within the RDS instance. This will be the initial database created upon instance launch."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "db_username" {
  description = "The master username for the RDS database instance. This user will have administrative privileges."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC (Virtual Private Cloud) where the RDS instance will be provisioned. This should be the same VPC as your EKS cluster."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "deletion_protection" {
  description = "When set to true, this prevents the RDS instance from being accidentally deleted. It's highly recommended for production environments."
  default     = false
  nullable    = false
  sensitive   = false
  type        = bool
}

variable "skip_final_snapshot" {
  description = "When set to true, a final DB snapshot is not created before the DB instance is deleted. Set to false for production to retain a snapshot."
  default     = true
  nullable    = false
  sensitive   = false
  type        = bool
}

variable "backup_retention_period" {
  description = "The number of days for which automated backups are retained. A value of 0 disables automated backups. Recommended to be greater than 0 for recovery purposes."
  default     = 14
  nullable    = false
  sensitive   = false
  type        = number
}

variable "vault_name" {
  description = "The name of the AWS Secrets Manager secret that stores the master password for the RDS instance. This is used to securely retrieve the password during provisioning."
  nullable    = false
  sensitive   = false
  type        = string
}
