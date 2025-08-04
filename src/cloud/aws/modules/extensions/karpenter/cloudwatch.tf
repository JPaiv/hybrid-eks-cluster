resource "aws_cloudwatch_event_rule" "karpenter" {
  for_each = { for k, v in local.events : k => v }

  description   = each.value.description
  event_pattern = jsonencode(each.value.event_pattern)
  name_prefix   = "${each.value.name}-"

  tags = merge(
    {
      "Description" : "Karpenter interruption queue event rules"
      "Name" : "${var.cluster_id}-karpenter-interruption-queue-event-rules"
    },
  )
}

resource "aws_cloudwatch_event_target" "karpenter" {
  for_each = { for k, v in local.events : k => v }

  arn       = aws_sqs_queue.karpenter.arn
  rule      = aws_cloudwatch_event_rule.karpenter[each.key].name
  target_id = "KarpenterInterruptionQueueTarget"
}
