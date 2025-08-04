
## -- EKS

variable "cluster_id" {
  description = "EKS Cluster id/name; same as the id_label"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS Cluster id/name; same as the id_label"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "node_role_arn" {
  default   = "EKS Node Role ARN from the EKS module"
  nullable  = false
  sensitive = false
  type      = string
}

variable "node_role_name" {
  default   = "EKS Node Role Name from the EKS module"
  nullable  = false
  sensitive = false
  type      = string
}

variable "oidc_identity_issuer_url" {
  description = "OIDC Identity issues URL from the EKS Cluster"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Identity Provider arn from the EKS Cluster"
  nullable    = false
  sensitive   = false
  type        = string
}

## -- Helm

variable "chart_version" {
  default     = "1.5.3"
  description = "Helm chart version -- ref: https://github.com/aws/karpenter-provider-aws/tree/main"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  description = "Helm chart install namespace"
  default     = "kube-system"
  nullable    = false
  sensitive   = false
  type        = string
}
