# ---------------------------------------------------------------------------------------------------------------------
# KARPENTER INTERRUPTION EVENTS
# Install Karpenter Controller on the EKS Managed Node Group
# Only use Bottlerocket Linux
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for k, v in local.events : k => v }

  description   = each.value.description
  event_pattern = jsonencode(each.value.event_pattern)
  name_prefix   = "${each.value.name}-"

  tags = merge(
    {
      "Description" : each.value.description
      "Name" : "${var.cluster_id}-karpenter-interruption-queue"
    },
  )
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = { for k, v in local.events : k => v }

  arn       = aws_sqs_queue.this.arn
  rule      = aws_cloudwatch_event_rule.this[each.key].name
  target_id = "KarpenterInterruptionQueueTarget"
}
