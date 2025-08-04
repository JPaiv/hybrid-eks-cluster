resource "aws_iam_role" "hybrid" {
  name               = "${var.id_label}-hybrid-role"
  assume_role_policy = data.aws_iam_policy_document.hybrid_trust_relationships.json

  tags = {
    "Description" = "Hybrid Node Role SSM Authentication"
    "Name"        = "${var.id_label}-hybrid-role"
  }
}

data "aws_iam_policy_document" "hybrid_trust_relationships" {
  policy_id = "TrustRelationships"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableOnPremSSMAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "ssm.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "hybridAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.hybrid.name
}

resource "aws_iam_role_policy_attachment" "hybridAmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.hybrid.name
}

resource "aws_iam_role_policy_attachment" "hybridAmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.hybrid.name
}

resource "aws_iam_role_policy_attachment" "hybridAmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.hybrid.name
}
