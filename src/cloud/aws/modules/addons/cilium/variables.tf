# ---------------------------------------------------------------------------------------------------------------------
# CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_id" {
  description = "The name of the EKS cluster."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace where Cilium will be deployed. Defaults to kube-system."
  default     = "kube-system"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint URL of the EKS cluster's API server."
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# AUTH
# ---------------------------------------------------------------------------------------------------------------------

variable "oidc_identity_issuer_url" {
  description = "The issuer URL of the EKS cluster's OIDC identity provider."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "oidc_provider_arn" {
  description = "The ARN of the EKS cluster's OIDC provider."
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# HELM
# ---------------------------------------------------------------------------------------------------------------------

variable "chart_version" {
  description = "The version of the Cilium Helm chart (see: https://artifacthub.io/packages/helm/cilium/cilium)."
  nullable    = false
  sensitive   = false
  type        = string
}
