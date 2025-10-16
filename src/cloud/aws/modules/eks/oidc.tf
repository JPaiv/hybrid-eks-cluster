# ---------------------------------------------------------------------------------------------------------------------
# EKS CLUSTER OIDC
# User as a Workload Identity Federation
# ref: https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
# ---------------------------------------------------------------------------------------------------------------------

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    data.tls_certificate.this.certificates[0].sha1_fingerprint,
  ]

  tags = {
    "Description" = "EKS OIDC provider"
    "Name"        = "${aws_eks_cluster.this.name}-oidc-provider"
  }
}
