resource "aws_route53_record" "elasticsearch" {
  zone_id = var.hosted_zone_id
  name    = "elasticsearch.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.elasticsearch_elb.dns_name
    zone_id                = aws_elb.elasticsearch_elb.zone_id
    evaluate_target_health = true
  }
}