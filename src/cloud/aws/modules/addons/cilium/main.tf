# ---------------------------------------------------------------------------------------------------------------------
# CILIUM CNI
# Replaces the AWS Managed CNI
# Operator instructions:
# -> Deploy Managed Node Group and addons with the Cilium module at the same time
# For some reason the EKS API endpoint cannot have https:// as part of the URL
# ---------------------------------------------------------------------------------------------------------------------

resource "helm_release" "this" {
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = false
  force_update     = true
  recreate_pods    = true
  replace          = true
  reset_values     = true
  reuse_values     = false
  skip_crds        = false
  timeout          = 600
  verify           = false
  wait             = true
  wait_for_jobs    = true

  chart      = "cilium"
  name       = local.name_label
  namespace  = var.namespace
  repository = "https://helm.cilium.io/"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        CHART_VERSION = var.chart_version
        EKS_ENDPOINT  = replace(var.cluster_endpoint, "https://", "") # Remove https:// from the endpoint URL
        IRSA_ARN      = aws_iam_role.this.arn
        IRSA_NAME     = aws_iam_role.this.name
        NAME_LABEL    = local.name_label
        STAGE         = local.stage
      }
    )
  ]
}
