output "sonarqube" {
  value = "https://${aws_route53_record.sonarqube.name}"
}