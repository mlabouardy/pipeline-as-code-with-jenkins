output "prometheus" {
  value = "https://${aws_route53_record.prometheus.name}"
}