## -- EKS

variable "cluster_id" {
  description = "EKS Cluster name"
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

variable "oidc_provider_arn" {
  description = "EKS Cluster OIDC Provider ARN"
  nullable    = false
  sensitive   = false
  type        = string
}

## --  Helm chart

variable "chart_version" {
  description = "Helm chart version, ref: https://artifacthub.io/packages/helm/external-secrets-operator/external-secrets"
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
