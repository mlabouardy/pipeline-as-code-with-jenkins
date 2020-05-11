resource "aws_route53_record" "visualizer" {
  zone_id = var.hosted_zone_id
  name    = "visualizer.${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.visualizer_elb.dns_name
    zone_id                = aws_elb.visualizer_elb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "movies_store" {
  zone_id = var.hosted_zone_id
  name    = "api.${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.movies_store_elb.dns_name
    zone_id                = aws_elb.movies_store_elb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "movies_marketplace" {
  zone_id = var.hosted_zone_id
  name    = "marketplace.${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.movies_marketplace_elb.dns_name
    zone_id                = aws_elb.movies_marketplace_elb.zone_id
    evaluate_target_health = true
  }
}