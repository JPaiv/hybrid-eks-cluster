resource "aws_acm_certificate" "this" {
  for_each = var.cert_domains

  domain_name       = "${each.value.name}.unikiemarshalling.com"
  validation_method = "DNS"

  validation_option {
    domain_name       = "${each.value.name}.unikiemarshalling.com"
    validation_domain = "unikiemarshalling.com"
  }

  tags = {
    "Description" = "${each.value.name}.unikiemarshalling.com DNS certificate"
    "Name"        = "${each.value.name}.unikiemarshalling.com"
  }
}

resource "aws_route53_record" "this" {
  for_each = var.cert_domains

  # Get domain validation options as a list
  # List has only one element, because only one domain validation option is used
  #Take the resource record attributes from the validation option map
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.this[each.key].domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.this[each.key].domain_validation_options)[0].resource_record_value] # Set of strings required
  ttl             = 300
  type            = tolist(aws_acm_certificate.this[each.key].domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.this.zone_id

  lifecycle {
    ignore_changes = [
      zone_id,
    ]
  }
}

resource "aws_acm_certificate_validation" "this" { # Set of strings required
  for_each = var.cert_domains

  certificate_arn         = aws_acm_certificate.this[each.key].arn
  validation_record_fqdns = [aws_route53_record.this[each.key].fqdn] # Set of strings required
}
