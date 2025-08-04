// -- EKS Cluster --

variable "cluster_id" {
  description = "EKS Cluster Name"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  default     = "auth"
  description = "Helm chart installation namespace; must exists priot to install!"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "chart_version" {
  description = "Ref: https://artifacthub.io/packages/helm/goauthentik/authentik"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "skey_secr_name" {
  description = "AWS Secrets Manager secret with the Secret Key for signing token and IDs"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "rds_ssm_param_name" {
  description = "AWS Parameter Store parameter with RDS module outputs"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "rds_pass_secr_name" {
  description = "AWS RDS Postgress instance password"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "redis_ssm_param_name" {
  description = "Redis cache configs SSM Parameter store name"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "redis_pass_secr_name" {
  description = "AWS Secrets Manager secret name"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "ses_secr_name" {
  description = "SES module access key and secret key Secrets Manager secret name"
  nullable    = false
  sensitive   = false
  type        = string
}
