locals {
  stage = element(split("-", var.cluster_id), 2)
  # Naming
  irsa_name  = "${var.cluster_id}-${var.namespace}-grafana-irsa"
  name_label = "${var.namespace}-kube-stack"
}
