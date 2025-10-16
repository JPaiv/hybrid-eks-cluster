# ---------------------------------------------------------------------------------------------------------------------
# EBS CSI PERSISTENT VOLUME ADDON IRSA
# Namespace: kube-system
# Service account: ebs-csi-controller-sa
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "ebs" {
  assume_role_policy = data.aws_iam_policy_document.ebs_trust_relationships.json
  name               = "${var.id_label}-ebs-csi-irsa"

  tags = {
    "Description" = "Persistent Volume EBS CSI Driver IRSA"
    "Name"        = "${var.id_label}-ebs-csi-irsa"
  }
}

data "aws_iam_policy_document" "ebs_trust_relationships" {
  policy_id = "TrustPolicy"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "AllowEOidcAssumeRole"

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "StringLike"
      variable = "${replace("${aws_eks_cluster.this.identity[0].oidc[0].issuer}", "https://", "")}:aud"
      values = [
        "sts.amazonaws.com",
      ]
    }

    condition {
      test     = "StringLike"
      variable = "${replace("${aws_eks_cluster.this.identity[0].oidc[0].issuer}", "https://", "")}:sub"
      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa",
      ]
    }

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.this.arn,
      ]
    }
  }
}

# ref: https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEBSCSIDriverPolicy.html
resource "aws_iam_role_policy_attachment" "ebsAmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs.name
}
