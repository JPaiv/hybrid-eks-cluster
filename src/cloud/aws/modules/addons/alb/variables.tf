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
  description = "The ARN of the EKS cluster's OIDC provider."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "oidc_identity_issuer_url" {
  description = "The issuer URL of the EKS cluster's OIDC identity provider."
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_id" {
  description = "The ID of the VPC associated with the EKS cluster."
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# HELM
# ---------------------------------------------------------------------------------------------------------------------

variable "chart_version" {
  description = "The version of the AWS Load Balancer Controller Helm chart (see: https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller)."
  nullable    = false
  sensitive   = false
  type        = string
}

