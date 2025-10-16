data "aws_region" "current" {}

data "aws_ssm_parameter" "cluster" {
  name = "/eks/ums-ec1-prod-core"
}

data "aws_ssm_parameter" "vpc" {
  name = "/vpc/ums-ec1-prod-core"
}
