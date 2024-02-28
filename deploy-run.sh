#!/bin/sh
# Apply Terraform configuration
cd /terraform
terraform init
terraform refresh
terraform apply -auto-approve

# Extract the Lambda function invocation URLs
FIRST_LAMBDA_URL=$(terraform output -raw first_lambda_invoke_url)
SECOND_LAMBDA_URL=$(terraform output -raw second_lambda_invoke_url)

# Invoke Lambda functions
echo "Invoking First Lambda at $FIRST_LAMBDA_URL"
curl "$FIRST_LAMBDA_URL"

echo "\nInvoking Second Lambda at $SECOND_LAMBDA_URL"
curl "$SECOND_LAMBDA_URL"
