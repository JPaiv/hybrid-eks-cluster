## -- EKS --

variable "cluster_id" {
  description = "EKS Cluster Name"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "oidc_identity_issuer_url" {
  description = "EKS Cluster OIDC Identity Issuer url"
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

## -- Helm

variable "chart_version" {
  description = "Helm chart version; ref: https://artifacthub.io/packages/helm/cilium/cilium"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  default   = "kube-system"
  nullable  = false
  sensitive = false
  type      = string
}
