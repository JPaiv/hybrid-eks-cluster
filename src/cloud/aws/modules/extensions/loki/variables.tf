// -- EKS Cluster

variable "cluster_id" {
  description = "EKS Cluster id/name; same as the id_label"
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

// -- Loki Helm

variable "chart_version" {
  default     = "6.32.0"
  description = "Loki Helm chart version; ref: https://artifacthub.io/packages/helm/grafana/loki"
  nullable    = false
  sensitive   = false
  type        = string
}

variable "loki_buckets" {
  description = "Loki required two s3 Buckets as storage and cache"
  nullable    = false
  sensitive   = false
  type        = map(map(string))

  default = {
    "chunks" = {
      name            = "chunks"
      versioning      = "Disabled"
      expiration_days = "1095"
    },

    "ruler" = {
      name            = "ruler"
      versioning      = "Disabled"
      expiration_days = "1095"
    }
  }
}

variable "namespace" {
  default     = "monitoring"
  description = "Same namespace as with all the other monitoring components"
  nullable    = false
  sensitive   = false
  type        = string
}
