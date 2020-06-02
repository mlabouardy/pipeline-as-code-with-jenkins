output "grafana" {
  value = "https://${aws_route53_record.grafana.name}"
}