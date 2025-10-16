# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_id" {
  description = "The name of the EKS cluster."
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

variable "oidc_identity_issuer_url" {
  description = "The issuer URL of the EKS cluster's OIDC identity provider."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC associated with the EKS cluster."
  nullable    = false
  sensitive   = false
  type        = string
}

variable "chart_version" {
  description = "The version of the AWS Load Balancer Controller Helm chart (see: https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller)."
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "namespace" {
  default     = "kube-system"
  description = "The namespace where the AWS Load Balancer Controller will be deployed. Defaults to kube-system."
  nullable    = false
  sensitive   = false
  type        = string
}
