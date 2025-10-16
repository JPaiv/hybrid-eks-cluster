variable "cluster_id" {
  description = "EKS Cluster ID"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "ingress_url" {
  description = "Ingress base hostname"
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
  description = "EKS Cluster OIDC Identity issuer url"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "chart_version" {
  default     = "8.1.3"
  description = "ArgoCD Helm chart version, ref: https://artifacthub.io/packages/helm/argo/argo-cd"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  default     = "ci-cd"
  description = "ArgoCD install namespace; should not be kube-system or other k8s necessary namespace"
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

variable "vault_admin" {
  nullable  = false
  sensitive = false
  type      = string
}

variable "vault_redis" {
  nullable  = false
  sensitive = false
  type      = string
}
