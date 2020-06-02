output "logstash" {
  value = "https://${aws_route53_record.logstash.name}"
}