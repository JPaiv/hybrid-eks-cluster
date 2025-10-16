resource "aws_sqs_queue" "this" {
  message_retention_seconds = 300
  name                      = "${var.cluster_id}-karpenter-node-disruption"

  tags = {
    "Description" = "Karpenter worker node disruption"
    "Name"        = "${var.cluster_id}-karpenter-node-disruption-queue"
  }
}

resource "aws_sqs_queue_policy" "this" {
  policy    = data.aws_iam_policy_document.sqs.json
  queue_url = aws_sqs_queue.this.url
}

data "aws_iam_policy_document" "sqs" {
  policy_id = "KarpenterSqsDisruptionQueuePermissions"
  version   = "2012-10-17"
  statement {
    effect = "Allow"
    sid    = "AllowSqsMessages"

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.this.arn
    ]

    principals {
      type = "Service"

      identifiers = [
        "events.amazonaws.com",
        "sqs.amazonaws.com"
      ]
    }
  }
}
