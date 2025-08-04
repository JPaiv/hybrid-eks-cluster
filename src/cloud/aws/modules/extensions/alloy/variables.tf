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
