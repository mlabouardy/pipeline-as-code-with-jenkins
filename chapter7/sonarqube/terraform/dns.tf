resource "aws_route53_record" "sonarqube" {
  zone_id = var.hosted_zone_id
  name    = "sonarqube.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.sonarqube_elb.dns_name
    zone_id                = aws_elb.sonarqube_elb.zone_id
    evaluate_target_health = true
  }
}