resource "helm_release" "argo_cd" {
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

  chart      = "argo-cd"
  name       = var.namespace
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  version    = var.chart_version

  values = [
    templatefile("${path.module}/templates/values.yaml", {
      chart_version  = var.chart_version
      eks_cluster_id = var.cluster_id
      id_label       = local.name_label
      irsa_arn       = aws_iam_role.this.arn
      irsa_name      = aws_iam_role.this.name
      namespace      = var.namespace
      redis_host     = local.redis_params.endpoint
      redis_password = jsondecode(data.aws_secretsmanager_secret_version.redis.secret_string)["password"]
      redis_port     = local.redis_params.port
      stage          = local.stage
      admin_pass     = jsondecode(data.aws_secretsmanager_secret_version.admin_pass.secret_string)["hashed_password"]
      }
    )
  ]
}
