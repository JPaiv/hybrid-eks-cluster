locals {
  stage          = element(split("-", var.cluster_id), 2)
  name_label     = "${var.namespace}-loki"
  irsa_name      = "${var.cluster_id}-${local.name_label}-irsa"
  bucket_id_base = "${var.cluster_id}-${local.name_label}"
}
