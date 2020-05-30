output "api" {
    value = aws_api_gateway_deployment.test.invoke_url
}

output "sandbox" {
    value = aws_api_gateway_deployment.sandbox.invoke_url
}

output "staging" {
    value = aws_api_gateway_deployment.staging.invoke_url
}

output "production" {
    value = aws_api_gateway_deployment.production.invoke_url
}

output "marketplace" {
    value = aws_s3_bucket.marketplace.website_endpoint
}