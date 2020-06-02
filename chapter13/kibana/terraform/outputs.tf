output "kibana" {
  value = "https://${aws_route53_record.kibana.name}"
}