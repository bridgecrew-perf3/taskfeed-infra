
provider "aws" {
  region = "us-east-2"
}

terraform {
  required_version = "~> 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket  = "taskfeed-terraform-state"
    key     = "dev/dev-api-gateway/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

locals {
  environment  = "Dev"
  organization = "TaskFeed"
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name           = "dev-taskfeed-rest"
  description    = "TaskFeed REST API used for development"
  api_key_source = "HEADER"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    "Organization" = local.organization
    "Environment"  = local.environment
    "Terraform"    = "true"
  }
}

resource "aws_api_gateway_resource" "resource_tasks" {
  path_part   = "tasks"
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_method" "method_tasks_get" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource_tasks.id
  http_method   = "GET"
  authorization = "NONE"
}

data "aws_lambda_function" "func_tasks_get" {
  function_name = "dev-tasks-get"
}

resource "aws_api_gateway_integration" "integration_tasks_get" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource_tasks.id
  http_method             = aws_api_gateway_method.method_tasks_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.func_tasks_get.invoke_arn
}

resource "aws_lambda_permission" "perms_tasks_get" {
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.func_tasks_get.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-2:889814911094:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.method_tasks_get.http_method}/tasks"
}

#-----------------------------------------------------------------

resource "aws_api_gateway_method" "method_tasks_post" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource_tasks.id
  http_method   = "POST"
  authorization = "NONE"
}

data "aws_lambda_function" "func_tasks_post" {
  function_name = "dev-tasks-post"
}

resource "aws_api_gateway_integration" "integration_tasks_post" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource_tasks.id
  http_method             = aws_api_gateway_method.method_tasks_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.func_tasks_post.invoke_arn
}

resource "aws_lambda_permission" "perms_tasks_post" {
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.func_tasks_post.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-2:889814911094:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.method_tasks_post.http_method}/tasks"
}

#----------------------------------------------------------------

resource "aws_api_gateway_method" "method_tasks_put" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource_tasks.id
  http_method   = "PUT"
  authorization = "NONE"
}

data "aws_lambda_function" "func_tasks_put" {
  function_name = "dev-tasks-put"
}

resource "aws_api_gateway_integration" "integration_tasks_put" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource_tasks.id
  http_method             = aws_api_gateway_method.method_tasks_put.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.func_tasks_put.invoke_arn
}

resource "aws_lambda_permission" "perms_tasks_put" {
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.func_tasks_put.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-2:889814911094:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.method_tasks_put.http_method}/tasks"
}

#-----------------------------------------------------------------

resource "aws_api_gateway_method" "method_tasks_delete" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.resource_tasks.id
  http_method   = "DELETE"
  authorization = "NONE"
}

data "aws_lambda_function" "func_tasks_delete" {
  function_name = "dev-tasks-delete"
}

resource "aws_api_gateway_integration" "integration_tasks_delete" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource_tasks.id
  http_method             = aws_api_gateway_method.method_tasks_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.func_tasks_delete.invoke_arn
}

resource "aws_lambda_permission" "perms_tasks_delete" {
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.func_tasks_delete.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-2:889814911094:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.method_tasks_delete.http_method}/tasks"
}

#---------------------------------------------------------------

resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  description = "API Gateway deployment for the ${local.environment} stage."

  triggers = {
    "redeployment" = sha1(jsonencode([
      aws_api_gateway_resource.resource_tasks.id,
      aws_api_gateway_method.method_tasks_get,
      aws_api_gateway_method.method_tasks_post,
      aws_api_gateway_method.method_tasks_put,
      aws_api_gateway_method.method_tasks_delete
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "rest_api_stage" {
  stage_name    = local.environment
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
}
