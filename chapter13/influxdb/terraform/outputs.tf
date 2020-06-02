output "influxdb" {
  value = "https://${aws_route53_record.influxdb.name}"
}