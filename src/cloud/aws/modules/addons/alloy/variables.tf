# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_id" {
  description = "EKS Cluster id/name; same as the id_label"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "chart_version" {
  description = "ref: https://artifacthub.io/packages/helm/grafana/alloy"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  default   = "monitoring"
  nullable  = false
  sensitive = false
  type      = string
}

variable "loki_lbalancer_url" {
  default     = "loki.unikiemarshalling.com"
  description = "Same namespace as with all the other monitoring components"
  nullable    = false
  sensitive   = false
  type        = string
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

variable "vault_name" {
  description = "Loki gateway basic auth password AWS Secrets Manager"
  nullable    = false
  sensitive   = false
  type        = string
}
