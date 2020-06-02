resource "aws_route53_record" "kibana" {
  zone_id = var.hosted_zone_id
  name    = "kibana.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.kibana_elb.dns_name
    zone_id                = aws_elb.kibana_elb.zone_id
    evaluate_target_health = true
  }
}