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

variable "vpc_id" {
  description = "EKS Cluster VPC ID"
  nullable    = false
  sensitive   = false
  type        = string
}

// -- Helm
variable "chart_version" {
  description = "AWS LB Controller Helm Chart version -- ref: https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  default     = "kube-system"
  description = "Deployment target namespace -- Use kube-system or else something will break"
  nullable    = false
  sensitive   = false
  type        = string
}
