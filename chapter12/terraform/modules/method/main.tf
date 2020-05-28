resource "aws_api_gateway_method" "request_method" {
   rest_api_id   = var.api_id
   resource_id   = var.resource_id
   http_method   = var.method
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "request_integration" {
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_method.request_method.resource_id
  http_method = aws_api_gateway_method.request_method.http_method
  type        = "AWS_PROXY"
  uri         = var.invoke_arn

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = var.lambda_arn
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.api_execution_arn}/*/*/*"
}

resource "aws_api_gateway_method_response" "response_method" {
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_method.request_method.resource_id
  http_method = aws_api_gateway_integration.request_integration.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "response_method_integration" {
  rest_api_id = var.api_id
  resource_id = aws_api_gateway_method.request_method.resource_id
  http_method = aws_api_gateway_method_response.response_method.http_method
  status_code = aws_api_gateway_method_response.response_method.status_code

  response_templates = {
    "application/json" = ""
  }
}
