variable "cluster_id" {
  description = "Consistent naming label as a unique resource identifier"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "port" {
  description = "Redis port number"
  default     = 6379
  nullable    = false
  sensitive   = false
  type        = number
}

variable "cache_name" {
  description = "Elasticache cluster name"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "elasticache_logs" {
  description = "Elasticache logs and Cloudwatch log group"
  nullable    = false
  sensitive   = false
  type = map(
    object
    (
      {
        log_group_class   = string
        log_type          = string
        retention_in_days = number
      }
    )
  )

  default = {
    "slow" = {
      log_group_class   = "STANDARD"
      log_type          = "slow-log"
      retention_in_days = 90
    }
    "engine" = {
      log_group_class   = "STANDARD"
      log_type          = "engine-log"
      retention_in_days = 90
    }
  }
}

variable "vault_name" {
  description = "Cache AWS Secrets Manager name"
  nullable    = false
  sensitive   = true
  type        = string
}

variable "priv_subnet_ids" {
  description = "A list of private subnet IDs where the RDS instance will be deployed. These subnets should be part of the EKS cluster's VPC and configured to prevent public access."
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC (Virtual Private Cloud) where the RDS instance will be provisioned. This should be the same VPC as your EKS cluster."
  nullable    = false
  sensitive   = false
  type        = string
}
