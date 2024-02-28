# Base structure
The tf files are in the root of the rpository and provide all needed to deploy the lambda functions. 

# Docker compose
Runs localstack and a TF-Apply-Run workflow that should get the API endpoint from the apply and get the data but that doesn't work becuse the lambda function is in a docker iamge and that will only work on localstack-pro