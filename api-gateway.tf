# API Gateway for First Lambda
resource "aws_api_gateway_resource" "first_lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "first-lambda"
}

resource "aws_api_gateway_method" "first_lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.first_lambda_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "first_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.first_lambda_resource.id
  http_method = "ANY"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.first_lambda.invoke_arn
}

# API Gateway for Second Lambda
resource "aws_api_gateway_resource" "second_lambda_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "second-lambda"
}

resource "aws_api_gateway_method" "second_lambda_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.second_lambda_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "second_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.second_lambda_resource.id
  http_method = "ANY"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.second_lambda.invoke_arn
}

resource "aws_lambda_permission" "first_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGatewayFirstLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.first_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/first-lambda/*"
}

resource "aws_lambda_permission" "second_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGatewaySecondLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.second_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/second-lambda/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.first_lambda_integration,
    aws_api_gateway_integration.second_lambda_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "test"
}
resource "aws_api_gateway_rest_api" "api" {
  name        = "LambdaAPI"
  description = "API Gateway for Lambda Functions"
}
