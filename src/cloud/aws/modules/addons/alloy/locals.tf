locals {
  stage      = element(split("-", var.cluster_id), 2)
  name_label = "${var.namespace}-alloy"
  irsa_name  = "${var.cluster_id}-${local.name_label}-irsa"
}
