resource "helm_release" "alloy" {
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = false
  force_update     = true
  recreate_pods    = true
  replace          = true
  reset_values     = true
  reuse_values     = false
  skip_crds        = false
  timeout          = 400
  verify           = false
  wait             = true
  wait_for_jobs    = true

  chart      = "alloy"
  name       = local.id_label
  namespace  = var.namespace
  repository = "https://grafana.github.io/helm-charts"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      cluster_id = var.cluster_id
      }
    )
  ]
}
