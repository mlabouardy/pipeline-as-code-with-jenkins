resource "aws_iam_role" "role" {
  name = "${var.name}Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
  filename      = "deployment.zip"
  function_name = var.name
  role          = aws_iam_role.role.arn
  handler       = var.handler
  runtime = var.runtime
  timeout = 10

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = var.environment
    }
  }

  tags = {
    Stack = "Watchlist"
  }
}

