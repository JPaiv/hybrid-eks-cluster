variable "cluster_id" {
  description = "EKS Cluster Name"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS Cluster OIDC Provider ARN"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "oidc_identity_issuer_url" {
  description = "EKS Cluster OIDC identity issuer url"
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

variable "vault_skey" {
  description = "AWS Secrets Manager secret with the Secret Key for signing token and IDs"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "vault_redis" {
  description = "AWS Secrets Manager secret with the Secret Key for signing token and IDs"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "vault_rds" {
  description = "AWS Secrets Manager secret with the Secret Key for signing token and IDs"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "rds_ssm" {
  description = "AWS Parameter Store parameter with RDS module outputs"
  nullable    = false
  sensitive   = false
  type        = string
}


variable "redis_ssm" {
  description = "Redis cache configs SSM Parameter store name"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "abac_tags" {
  description = "Map of attribute-based access control (ABAC) tags to apply, where the key is the tag name and the value is an object of tag details."
  default     = null
  nullable    = true
  sensitive   = false
  type = map(object({
    tag_type    = string
    abac_key    = string
    abac_values = list(string)
  }))
}

variable "ingress_url" {
  description = "Ingress base hostname"
  nullable    = false
  sensitive   = false
  type        = string
}
