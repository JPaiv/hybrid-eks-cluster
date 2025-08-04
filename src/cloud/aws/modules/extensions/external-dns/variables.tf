## -- EKS

variable "cluster_id" {
  description = "EKS Cluster name"
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
  description = "EKS Cluster OIDC Identity Issuer URL"
  nullable    = false
  sensitive   = false
  type        = string
}

## -- Helm

variable "chart_version" {
  default     = "1.18.0"
  description = "External-DNS Helm Chart version -- https://artifacthub.io/packages/helm/external-dns/external-dns"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  default     = "kube-system"
  description = "Helm chart install namesapce"
  nullable    = false
  sensitive   = false
  type        = string
}
