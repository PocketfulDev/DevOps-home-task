variable "region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}
resource "aws_lambda_function" "first_lambda" {
  function_name = "FirstLambdaFunction"

  package_type = "Image"
  image_uri    = "jonathanpick/first-lambda:v1"

  role = aws_iam_role.lambda_exec_role.arn
}

resource "aws_lambda_function" "second_lambda" {
  function_name = "SecondLambdaFunction"

  package_type = "Image"
  image_uri    = "jonathanpick/second-lambda:v1"

  role = aws_iam_role.lambda_exec_role.arn
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }]
}
EOF
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "LambdaAPI"
  description = "API Gateway for Lambda Functions"
}

resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.root_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "first_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.root_resource.id
  http_method = aws_api_gateway_method.proxy_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.first_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "second_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.root_resource.id
  http_method = aws_api_gateway_method.proxy_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.second_lambda.invoke_arn
}

output "first_lambda_invoke_url" {
  value = "http://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/{stage_name}/"
}

output "second_lambda_invoke_url" {
  value = "http://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/{stage_name}/"
}

