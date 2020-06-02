output "elasticsearch" {
  value = "https://${aws_route53_record.elasticsearch.name}"
}