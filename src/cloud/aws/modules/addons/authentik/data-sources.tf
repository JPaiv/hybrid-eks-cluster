# AWS Region
data "aws_region" "current" {}

# Account ID
data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "rds" {
  name = var.rds_ssm
}

data "aws_ssm_parameter" "redis" {
  name = var.redis_ssm
}
