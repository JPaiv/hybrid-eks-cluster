// -- Default: eu-central-1
data "aws_region" "current" {}

// -- Account ID
data "aws_caller_identity" "current" {}

// -- Default: eu-central-1 AZ's
data "aws_availability_zones" "current" {}

// -- Get the latest AWS Bottlerocket AMI Image
data "aws_ami" "bottlerocket_image" {
  most_recent = true
  owners = [
    "amazon",
  ]

  filter {
    name = "name"
    values = [
      "bottlerocket-aws-k8s-${var.cluster_version}-x86_64-*",
    ]
  }
}
