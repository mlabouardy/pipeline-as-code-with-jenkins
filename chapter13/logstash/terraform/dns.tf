resource "aws_route53_record" "logstash" {
  zone_id = var.hosted_zone_id
  name    = "logstash.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.logstash_elb.dns_name
    zone_id                = aws_elb.logstash_elb.zone_id
    evaluate_target_health = true
  }
}