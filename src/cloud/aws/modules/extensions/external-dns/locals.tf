locals {
  stage = element(split("-", var.cluster_id), 2)
  // -- Local names from input variables
  name_label = "${var.namespace}-external-dns"
  irsa_name  = "${local.name_label}-irsa"
}
