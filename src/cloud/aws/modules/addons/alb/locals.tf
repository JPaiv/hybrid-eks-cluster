locals {
  irsa_name  = "${var.cluster_id}-${local.name_label}-irsa"
  name_label = "${var.namespace}-lb-controller"
  stage      = element(split("-", var.cluster_id), 2)
}
