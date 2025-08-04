// ref: https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html
// ref: https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
resource "helm_release" "alb_controller" {
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

  chart      = "aws-load-balancer-controller"
  name       = var.namespace
  namespace  = var.namespace
  repository = "https://aws.github.io/eks-charts"
  version    = var.chart_version

  // ref: https://github.com/aws/eks-charts/blob/master/stable/aws-load-balancer-controller/values.yaml
  values = [
    templatefile("${path.module}/templates/values.yaml",
      {
        chart_version  = var.chart_version
        current_region = data.aws_region.current.name
        eks_cluster_id = var.cluster_id
        irsa_arn       = aws_iam_role.this.arn
        irsa_name      = aws_iam_role.this.name
        stage          = local.stage
        vpc_id         = var.vpc_id
      }
    )
  ]
}
