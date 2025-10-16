# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# EKS Cluster & OIDC
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_id" {
  description = "EKS Cluster id/name; same as the id_label"
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
  description = "EKS Cluster OIDC Identity issuer URL"
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Helm Chart
# ---------------------------------------------------------------------------------------------------------------------

variable "chart_vers" {
  description = "Helm chart version; ref: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  default     = "monitoring"
  description = "Namespace where the Prometheus and Grafana stack will be deployed"
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Secrets
# ---------------------------------------------------------------------------------------------------------------------

variable "vault_name" {
  description = "AWS Secrets Manager secret name containing the Grafana admin user password"
  nullable    = false
  sensitive   = false
  type        = string
}


# ---------------------------------------------------------------------------------------------------------------------
# ABAC Tags
# ---------------------------------------------------------------------------------------------------------------------

variable "abac_tags" {
  description = "ABAC tags to apply, where the key is the tag name and the value is an object of tag details."
  default     = null
  nullable    = true
  sensitive   = false
  type = map(object({
    tag_type    = string
    abac_key    = string
    abac_values = list(string)
  }))
}

variable "ingress_url" {
  description = "Ingress base hostname"
  nullable    = false
  sensitive   = false
  type        = string
}