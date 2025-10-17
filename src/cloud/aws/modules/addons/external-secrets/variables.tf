# ---------------------------------------------------------------------------------------------------------------------
# CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_id" {
  description = "EKS Cluster name"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  default     = "kube-system"
  description = "Deploy to namespace kube-system unless there is a reason for other namespace"
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# AUTH
# ---------------------------------------------------------------------------------------------------------------------

variable "oidc_provider_arn" {
  description = "EKS Cluster OIDC Provider ARN"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "oidc_identity_issuer_url" {
  description = "EKS Cluster OIDC Identity Issuer URL"
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# HELM
# ---------------------------------------------------------------------------------------------------------------------

variable "chart_version" {
  description = "Helm chart version, ref: https://artifacthub.io/packages/helm/external-secrets-operator/external-secrets"
  nullable    = false
  sensitive   = false
  type        = string
}
