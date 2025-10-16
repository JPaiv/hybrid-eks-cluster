# Route 53 unikiemarshalling.com
data "aws_route53_zone" "this" {
  name         = "unikiemarshalling.com"
  private_zone = false
}
