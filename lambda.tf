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

output "first_lambda_invoke_url" {
  value = "http://localstack:4566/restapis/${aws_api_gateway_rest_api.api.id}/test/_user_request_/first-lambda"
}

output "second_lambda_invoke_url" {
  value = "http://localstack:4566/restapis/${aws_api_gateway_rest_api.api.id}/test/_user_request_/second-lambda"
}
