output "nexus" {
  value = "https://${aws_route53_record.nexus.name}"
}

output "registry" {
  value = "https://${aws_route53_record.registry.name}"
}