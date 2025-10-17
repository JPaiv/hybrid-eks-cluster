# ---------------------------------------------------------------------------------------------------------------------
# CLUSTER
# -----------------------------§----------------------------------------------------------------------------------------

variable "cluster_id" {
  description = "EKS Cluster id/name; same as the id_label"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "oidc_identity_issuer_url" {
  description = "OIDC Identity issuer URL from the EKS Cluster"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Identity Provider ARN from the EKS Cluster"
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# HELM
# ---------------------------------------------------------------------------------------------------------------------

variable "chart_version" {
  description = "Loki Helm chart version; ref: https://artifacthub.io/packages/helm/grafana/loki"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "namespace" {
  default     = "monitoring"
  description = "Namespace for Loki and other monitoring components"
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# LOG STORAGE
# ---------------------------------------------------------------------------------------------------------------------

variable "loki_buckets" {
  description = "Loki requires two S3 Buckets for storage and cache"
  nullable    = false
  sensitive   = false
  type        = map(map(string))

  default = {
    "chunks" = {
      name            = "chunks"
      versioning      = "Disabled"
      expiration_days = "180"
    },

    "ruler" = {
      name            = "ruler"
      versioning      = "Disabled"
      expiration_days = "180"
    }
  }
}

variable "bucket_force_destroy" {
  default     = false
  description = "Toggle bucket forceful delete, true means that bucket is destroyed even if it has objects"
  nullable    = false
  sensitive   = false
  type        = bool
}

# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING
# ---------------------------------------------------------------------------------------------------------------------

variable "ingress_url" {
  description = "Ingress base hostname"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "vault_name" {
  description = "Gateway basic auth password stored in AWS Secrets Manager"
  nullable    = false
  sensitive   = false
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# ACCESS
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
