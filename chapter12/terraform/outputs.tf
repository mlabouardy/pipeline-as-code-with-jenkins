output "api" {
    value = aws_api_gateway_deployment.test.invoke_url
}

output "marketplace" {
    value = aws_s3_bucket.marketplace.website_endpoint
}