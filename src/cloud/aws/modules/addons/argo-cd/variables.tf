# ---------------------------------------------------------------------------------------------------------------------
# CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_id" {
  description = "EKS Cluster ID"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "namespace" {
  description = "ArgoCD install namespace; should not be kube-system or other Kubernetes system namespace"
  type        = string
  default     = "ci-cd"
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# AUTH
# ---------------------------------------------------------------------------------------------------------------------

variable "oidc_provider_arn" {
  description = "EKS Cluster OIDC Provider ARN"
  type        = string
  nullable    = false
  sensitive   = false
}

variable "oidc_identity_issuer_url" {
  description = "EKS Cluster OIDC Identity issuer URL"
  type        = string
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# HELM
# ---------------------------------------------------------------------------------------------------------------------

variable "chart_version" {
  description = "ArgoCD Helm chart version; ref: https://artifacthub.io/packages/helm/argo/argo-cd"
  type        = string
  default     = "8.1.3"
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# SECRETS
# ---------------------------------------------------------------------------------------------------------------------

variable "vault_admin" {
  description = "AWS Secrets Manager secret containing ArgoCD admin credentials"
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

# ---------------------------------------------------------------------------------------------------------------------
# REDIS PARAMS
# ---------------------------------------------------------------------------------------------------------------------

variable "redis_ssm" {
  description = "Redis cache configuration SSM Parameter Store name"
  type        = string
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING
# ---------------------------------------------------------------------------------------------------------------------

variable "ingress_url" {
  description = "Ingress base hostname"
  type        = string
  nullable    = false
  sensitive   = false
}

# ---------------------------------------------------------------------------------------------------------------------
# ACCESS
# ---------------------------------------------------------------------------------------------------------------------

variable "abac_tags" {
  description = "Map of attribute-based access control (ABAC) tags to apply. Key is tag name; value is an object with tag details."
  type = map(object({
    tag_type    = string
    abac_key    = string
    abac_values = list(string)
  }))
  default   = null
  nullable  = true
  sensitive = false
}
