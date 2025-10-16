locals {
  stage      = element(split("-", var.cluster_id), 2)
  irsa_name  = "${var.cluster_id}-${var.namespace}-cilium-operator-irsa"
  name_label = "${var.namespace}-cilium"
}
