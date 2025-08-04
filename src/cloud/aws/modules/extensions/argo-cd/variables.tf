## -- EKS Cluster

variable "cluster_id" {
  description = "EKS Cluster ID"
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

## -- Argo-CD Helm chart install

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

## -- Argo-CD Elasticache Redis

variable "redis_ssm_name" {
  description = "Redis cache configs SSM Parameter store name"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "admin_pass_secr_name" {
  description = "AWS Secrets Manager secret name"
  nullable    = false
  sensitive   = false
  type        = string
}


variable "redis_pass_secr_name" {
  description = "AWS Secrets Manager secret name"
  nullable    = false
  sensitive   = false
  type        = string
}
