resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.trust_relationships.json
  name               = "${local.name_label}-role"

  tags = {
    "Description" = "RDS Database ${local.name_label} Cloudwatch RDS Monitoring IAM Role"
    "Name"        = "${local.name_label}-role"
  }
}

data "aws_iam_policy_document" "trust_relationships" {
  policy_id = "TrustPolicy"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "AllowServiceAssumeRole"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "monitoring.rds.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "AmazonRDSEnhancedMonitoringRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.this.name
}
