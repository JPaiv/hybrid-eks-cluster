resource "helm_release" "loki" {
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

  chart      = "loki"
  name       = local.id_label
  namespace  = var.namespace
  repository = "https://grafana.github.io/helm-charts"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      chart_version      = var.chart_version
      chunks_bucket_id   = aws_s3_bucket.this["chunks"].id
      id_label           = local.id_label
      irsa_arn           = aws_iam_role.this.arn
      irsa_name          = aws_iam_role.this.name
      region             = data.aws_region.current.name
      ruler_bucket_id    = aws_s3_bucket.this["ruler"].id
      stage              = local.stage
      storage_class_name = local.id_label
      }
    )
  ]

  depends_on = [
    kubectl_manifest.storage_class,
  ]
}

resource "kubectl_manifest" "storage_class" {
  yaml_body = templatefile("${path.module}/templates/storage-class.yaml", {
    chart_version = var.chart_version
    id_label      = local.id_label
    stage         = local.stage
    }
  )
}
