resource "aws_sqs_queue" "karpenter" {
  message_retention_seconds = 300
  name                      = "${var.cluster_id}-karpenter-node-disruption-queue"

  tags = {
    "Description" = "Karpenter node disruption queue"
    "Name"        = "${var.cluster_id}-karpenter-node-disruption-queue"
  }
}

resource "aws_sqs_queue_policy" "karpenter" {
  policy    = data.aws_iam_policy_document.node_termination_queue.json
  queue_url = aws_sqs_queue.karpenter.url
}

data "aws_iam_policy_document" "node_termination_queue" {
  statement {
    sid = "EnableEc2Disruption"

    actions = [
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.karpenter.arn
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
