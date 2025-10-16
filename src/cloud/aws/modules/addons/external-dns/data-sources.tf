data "aws_region" "current" {}

data "aws_route53_zone" "this" {
  name         = "unikiemarshalling.com"
  private_zone = false
}
