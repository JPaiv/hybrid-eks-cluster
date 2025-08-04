locals {
  // -- Get ID elements
  stage = element(split("-", var.cluster_id), 2)

  // -- Create unique kube-stack id label
  id_label = "${var.namespace}-kube-stack"
}
