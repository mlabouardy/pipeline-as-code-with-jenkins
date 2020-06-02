resource "aws_route53_record" "influxdb" {
  zone_id = var.hosted_zone_id
  name    = "influxdb.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.influxdb_elb.dns_name
    zone_id                = aws_elb.influxdb_elb.zone_id
    evaluate_target_health = true
  }
}