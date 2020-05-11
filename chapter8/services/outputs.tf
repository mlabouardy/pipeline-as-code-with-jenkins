output "visualizer" {
  value = "https://${aws_route53_record.visualizer.name}"
}

output "store" {
  value = "https://${aws_route53_record.movies_store.name}"
}

output "marketplace" {
  value = "https://${aws_route53_record.movies_marketplace.name}"
}