locals {
  // -- Get ID elements
  stage = element(split("-", var.cluster_id), 2)

  // -- Loki ID Label
  id_label = "${var.namespace}-loki"

  // -- IRSA Name
  irsa_name = "${local.id_label}-irsa"

  // -- Bucket ID
  bucket_id_base = "${var.cluster_id}-${var.namespace}-loki"
}
