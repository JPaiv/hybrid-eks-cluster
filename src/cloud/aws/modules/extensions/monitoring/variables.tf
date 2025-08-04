
## -- EKS
variable "cluster_id" {
  description = "EKS Cluster id/name; same as the id_label"
  nullable    = false
  sensitive   = false
  type        = string
}

# -- Helm

variable "chart_vers" {
  description = "Helm chart version; ref: https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack"
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

variable "admin_pass_secr_name" {
  description = "Grafana admin user password AWS Secrets Manager secret name"
  nullable    = false
  sensitive   = false
  type        = string
}
