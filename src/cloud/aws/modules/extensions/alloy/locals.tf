locals {
  // -- Get ID elements
  stage = element(split("-", var.cluster_id), 2)

  // -- Loki ID Label
  id_label = "${var.namespace}-alloy"
}
