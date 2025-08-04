resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.ctrail_trusted_relationships.json
  name               = local.id_label

  tags = {
    "Description" = "Cloudtrail"
    "Name"        = local.id_label
  }
}

data "aws_iam_policy_document" "ctrail_trusted_relationships" {
  policy_id = "TrustRelationships"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableServiceTrustRelationships"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }

    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = "${aws_iam_role.this.id}-policy"
  policy = data.aws_iam_policy_document.ctrail_permissions.json

  tags = {
    "Description" = "Cloudtrail ${local.id_label} Permissions Policy"
    "Name"        = "${aws_iam_role.this.id}-policy"
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

data "aws_iam_policy_document" "ctrail_permissions" {
  policy_id = "Permissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "EnableCloudtrailReadWrite"

    actions = [
      "cloudtrail:*",
      "iam:CreateServiceLinkedRole",
      "iam:GetRole",
      "iam:ListRoles",
      "iam:PassRole",
      "kms:CreateKey",
      "kms:DescribeKey",
      "kms:EnableKeyRotation",
      "kms:GenerateDataKey*",
      "kms:ListAliases",
      "kms:ListKeys",
      "kms:PutKeyPolicy",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "s3:CreateBucket",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutBucketPolicy",
      "s3:PutObject",
      "sns:CreateTopic",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:Subscribe",
    ]

    resources = [
      "*",
    ]
  }
}
