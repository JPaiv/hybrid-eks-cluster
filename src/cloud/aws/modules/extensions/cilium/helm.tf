// -- Install Cilium
resource "helm_release" "cilium" {
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = false
  force_update     = true
  recreate_pods    = true
  replace          = true
  reset_values     = true
  reuse_values     = false
  skip_crds        = false
  timeout          = 300
  verify           = false
  wait             = true
  wait_for_jobs    = true

  chart      = "cilium"
  name       = "cilium"
  namespace  = var.namespace
  repository = "https://helm.cilium.io/"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        irsa_arn         = aws_iam_role.this.arn
        cluster_endpoint = replace(var.cluster_endpoint, "https://", "") // -- https:// is not needed in the values.yaml --> Causes an error
        cluster_id       = var.cluster_id
      }
    )
  ]
}
