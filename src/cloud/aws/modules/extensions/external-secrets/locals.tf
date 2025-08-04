locals {
  stage = element(split("-", var.cluster_id), 2)
  // -- General
  name_label = "${var.namespace}-external-secrets"
  irsa_name  = "${local.name_label}-irsa"
}
