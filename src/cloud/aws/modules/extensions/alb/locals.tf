locals {
  stage = element(split("-", var.cluster_id), 2)
  // -- Unique ID for the IRSA
  name_label = "${var.namespace}-alb-controller"
  irsa_name  = "${local.name_label}-irsa"
}
