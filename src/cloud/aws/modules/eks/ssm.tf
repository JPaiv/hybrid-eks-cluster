# ---------------------------------------------------------------------------------------------------------------------
# EKS CLUSTER PARAMS
# Used mainly by TF
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ssm_parameter" "this" {
  description = "EKS Cluster Params"
  name        = "/eks/${var.id_label}"
  type        = "String"

  value = jsonencode(
    {
      "cluster_arn"              = aws_eks_cluster.this.arn
      "cluster_endpoint"         = aws_eks_cluster.this.endpoint
      "cluster_id"               = aws_eks_cluster.this.id
      "hybrid_role_arn"          = aws_iam_role.hybrid.arn
      "hybrid_role_name"         = aws_iam_role.hybrid.name
      "node_role_arn"            = aws_iam_role.node.arn
      "node_role_name"           = aws_iam_role.node.name
      "oidc_identity_issuer_url" = aws_eks_cluster.this.identity[0].oidc[0].issuer
      "oidc_provider_arn"        = aws_iam_openid_connect_provider.this.arn
    }
  )

  tags = {
    "Description" = "EKS Cluster Params"
    "Name"        = "/eks/${var.id_label}"
  }
}
