locals {
  stage = element(split("-", var.cluster_id), 2)

  # Naming
  name_label = "${var.namespace}-argo-cd"
  irsa_name  = "${var.cluster_id}-${local.name_label}-server-irsa"

  # Database connection details:
  # -> endpoint
  # -> port
  redis = jsondecode(data.aws_ssm_parameter.this.value)
}
