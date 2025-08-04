resource "aws_ssm_parameter" "this" {
  // -- General
  description = "Cluster TF Configurations"
  name        = "/eks/${var.id_label}"
  type        = "SecureString"

  // -- Encryption
  key_id = aws_kms_key.ssm.arn

  value = jsonencode(
    {
      "certificate_authority_data" = aws_eks_cluster.this.certificate_authority[0].data
      "cluster_arn"                = aws_eks_cluster.this.arn
      "cluster_endpoint"           = aws_eks_cluster.this.endpoint
      "cluster_id"                 = aws_eks_cluster.this.id
      "hybrid_role_arn"            = aws_iam_role.hybrid.arn
      "hybrid_role_name"           = aws_iam_role.hybrid.name
      "node_role_arn"              = aws_iam_role.node.arn
      "node_role_name"             = aws_iam_role.node.name
      "oidc_identity_issuer_url"   = aws_eks_cluster.this.identity[0].oidc[0].issuer
      "oidc_provider_arn"          = aws_iam_openid_connect_provider.this.arn
    }
  )

  tags = {
    "Description" = "Cluster TF Configurations"
    "Name"        = "/eks/${var.id_label}"
  }
}
