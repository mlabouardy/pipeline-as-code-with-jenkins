variable "api_id" {
    type = string
    description = "API Gateway API ID"
}

variable "resource_id" {
    type = string
    description = "API resource ID"
}

variable "api_execution_arn" {
    type = string
    description = "API Gateway REST API execution ARN"
}

variable "lambda_arn" {
    type = string
    description = "Lambda function ARN"
}

variable "invoke_arn" {
    type = string
    description = "Lambda function invocation ARN"
}

variable "method" {
    type = string
    description = "HTTP method"
}