locals {
  // -- Get the deployment stage ID element
  stage = element(split("-", var.cluster_id), 2)

  // --   Argocd ID Label
  name_label = "${var.namespace}-argo-cd"

  // -- ArgoCD Server IRSA name
  irsa_name = "${local.name_label}-server-irsa"

  // -- Database connection details:
  // -- endpoint
  // -- port
  // -- password
  redis_params = jsondecode(data.aws_ssm_parameter.this.value)
}
