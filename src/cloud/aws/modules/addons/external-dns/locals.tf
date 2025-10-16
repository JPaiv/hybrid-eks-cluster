locals {
  id_label  = "${var.namespace}-external-dns"
  irsa_name = "${var.cluster_id}-${local.id_label}-irsa"
  stage     = element(split("-", var.cluster_id), 2)
}
