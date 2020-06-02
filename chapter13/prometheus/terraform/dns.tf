resource "aws_route53_record" "prometheus" {
  zone_id = var.hosted_zone_id
  name    = "prometheus.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.prometheus_elb.dns_name
    zone_id                = aws_elb.prometheus_elb.zone_id
    evaluate_target_health = true
  }
}