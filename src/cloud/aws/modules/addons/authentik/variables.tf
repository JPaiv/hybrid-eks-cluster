# ---------------------------------------------------------------------------------------------------------------------
# CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_id" {
  description = "EKS Cluster Name"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "namespace" {
  description = "Helm chart installation namespace; must exist prior to install!"
  type        = string
  default     = "auth"
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# AUTHENTICATION
# ---------------------------------------------------------------------------------------------------------------------

variable "oidc_provider_arn" {
  description = "EKS Cluster OIDC Provider ARN"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "oidc_identity_issuer_url" {
  description = "EKS Cluster OIDC identity issuer URL"
  type        = string
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# SECRETS
# ---------------------------------------------------------------------------------------------------------------------

variable "vault_skey" {
  description = "AWS Secrets Manager secret with the Secret Key for signing tokens and IDs"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "vault_redis" {
  description = "AWS Secrets Manager secret containing Redis credentials"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "vault_rds" {
  description = "AWS Secrets Manager secret containing RDS credentials"
  type        = string
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# DATABASE
# ---------------------------------------------------------------------------------------------------------------------

variable "rds_ssm" {
  description = "AWS Parameter Store parameter with RDS module outputs"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "redis_ssm" {
  description = "Redis cache configs SSM Parameter Store name"
  type        = string
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# HELM
# ---------------------------------------------------------------------------------------------------------------------

variable "chart_version" {
  description = "Ref: https://artifacthub.io/packages/helm/goauthentik/authentik"
  type        = string
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING
# ---------------------------------------------------------------------------------------------------------------------

variable "ingress_url" {
  description = "Ingress hostname"
  type        = string
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# ABAC
# ---------------------------------------------------------------------------------------------------------------------

variable "abac_tags" {
  description = "Map of attribute-based access control tags to apply, where the key is the tag name and the value is an object"
  type = map(object({
    tag_type    = string
    abac_key    = string
    abac_values = list(string)
  }))
  default   = null
  nullable  = true
  sensitive = false
}
