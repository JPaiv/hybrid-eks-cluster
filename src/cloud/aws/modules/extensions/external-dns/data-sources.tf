data "aws_region" "current" {}

data "aws_route53_zone" "this" {
  name         = ""
  private_zone = false
}
