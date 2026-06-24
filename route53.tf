locals {
  validation_records = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.resource_record_name => dvo
  }

  zone_id = data.aws_route53_zone.main.zone_id
}

resource "aws_route53_record" "myhosted_zone" {
  zone_id = local.zone_id
  name    = var.domain_name
  type    = "A"
  alias {

    name = aws_cloudfront_distribution.website.domain_name

    zone_id = aws_cloudfront_distribution.website.hosted_zone_id

    evaluate_target_health = false
  }
}

resource "aws_route53_record" "validation" {

  for_each = local.validation_records

  zone_id = local.zone_id

  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 300
  records = [each.value.resource_record_value]
  allow_overwrite = true
}


