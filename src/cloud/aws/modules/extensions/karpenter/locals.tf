locals {
  // -- Filter id_label
  stage = element(split("-", var.cluster_id), 2)

  // -- Karpenter Controller IRSA name
  name_label = "${var.namespace}-karpenter"
  irsa_name  = "${local.name_label}-irsa"

  // -- SQS Disruption Queue Event configs
  events = {
    health_event = {
      description = "Karpenter interrupt - AWS health event"
      name        = "HealthEvent"

      event_pattern = {
        detail-type = [
          "AWS Health Event"
        ]
        source = [
          "aws.health"
        ]
      }
    }

    spot_interupt = {
      description = "Karpenter interrupt - EC2 spot instance interruption warning"
      name        = "SpotInterrupt"

      event_pattern = {
        detail-type = [
          "EC2 Spot Instance Interruption Warning"
        ]
        source = [
          "aws.ec2"
        ]
      }
    }

    instance_rebalance = {
      description = "Karpenter interrupt - EC2 instance rebalance recommendation"
      name        = "InstanceRebalance"

      event_pattern = {
        detail-type = [
          "EC2 Instance Rebalance Recommendation"
        ]
        source = [
          "aws.ec2"
        ]
      }
    }

    instance_state_change = {
      description = "Karpenter interrupt - EC2 instance state-change notification"
      name        = "InstanceStateChange"

      event_pattern = {
        detail-type = [
          "EC2 Instance State-change Notification"
        ]
        source = [
          "aws.ec2"
        ]
      }
    }
  }
}
