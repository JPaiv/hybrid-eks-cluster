// -- Default: eu-central-1 AZ's
data "aws_availability_zones" "this" {}

// -- Default: eu-central-1
data "aws_region" "current" {}

// -- Account ID
data "aws_caller_identity" "current" {}
