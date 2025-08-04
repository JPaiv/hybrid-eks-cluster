resource "helm_release" "kube_prometheus_stack" {
  atomic           = true
  cleanup_on_fail  = true
  create_namespace = false
  force_update     = true
  recreate_pods    = true
  replace          = true
  reset_values     = true
  reuse_values     = false
  skip_crds        = false
  timeout          = 200
  verify           = false
  wait             = true
  wait_for_jobs    = true

  chart      = "kube-prometheus-stack"
  name       = local.id_label
  namespace  = var.namespace
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = var.chart_vers

  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        chart_version = var.chart_vers
        id_label      = local.id_label
        password      = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["password"]
        stage         = local.stage
      }
    )
  ]

  depends_on = [
    kubectl_manifest.storage_class,
  ]
}

resource "kubectl_manifest" "storage_class" {
  yaml_body = templatefile("${path.module}/templates/storage-class.yaml",
    {
      chart_version = var.chart_vers
      id_label      = local.id_label
      stage         = local.stage
    }
  )
}
