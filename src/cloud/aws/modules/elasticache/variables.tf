variable "cluster_id" {
  description = "Consistent naming label as a unique resource identifier"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "priv_subn_ids" {
  description = "Private Subnet ID's"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "sg_ids" {
  description = "Associated VPC security group ID's"
  nullable    = false
  sensitive   = false
  type        = list(string)
}

variable "eks_sg_id" {
  description = "AWS managed EKS worker node security group ID"
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

variable "vpc_id" {
  description = "Associated VPC security group ID's"
  nullable    = false
  sensitive   = false
  type        = string
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

variable "pass_secr_name" {
  description = "Redis auth token AWS Secrets Manager secret name"
  nullable    = false
  sensitive   = true
  type        = string
}
