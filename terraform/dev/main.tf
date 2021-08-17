
provider "aws" {
  region = "us-east-2"

}

terraform {
  required_version = "~> 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket  = "taskfeed-terraform-state"
    key     = "dev/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

locals {
  region      = "us-east-2"
  environment = "Dev"
}

module "api_gateway" {
  source = "../modules/api_gateway"

  name           = "taskfeed-rest-api"
  description    = "REST API for TaskFeed app."
  api_key_source = "HEADER"
  openapi_spec = templatefile("./files/taskfeed_spec_dev.yaml.tmpl", {
    region     = local.region
    lambda_arn = module.lambda_func.lambda_function_arn
  })
  api_endpoint_config_type = "REGIONAL"
  stage                    = local.environment

  tags = {
    "Environment" = local.environment
    "Terraform"   = "true"
  }
}

module "lambda_func" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "test_func"
  description   = "Test lambda function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  create_package = false
  s3_existing_package = {
    bucket = "taskfeed-backend"
    key    = "lambda_function.zip"
  }

  allowed_triggers = {
    "allow_APIGateway" = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_gateway_execution_arn}*/GET/tasks"
    }
  }

  publish = true
  tags = {
    "Environment" = local.environment
    "Terraform"   = "true"
  }
}

module "dynamodb_table_tasks" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name         = "tasks"
  billing_mode = "PROVISIONED"

  read_capacity  = 5
  write_capacity = 5

  hash_key  = "id"
  range_key = "owner"

  attributes = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "owner"
      type = "S"
    }
  ]

  tags = {
    "Environment" = local.environment
    "Terraform"   = "true"
  }

}

module "dynamodb_table_users" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name         = "users"
  billing_mode = "PROVISIONED"

  read_capacity  = 5
  write_capacity = 5

  hash_key = "username"

  attributes = [
    {
      name = "username"
      type = "S"
    }
  ]

  tags = {
    "Environment" = local.environment
    "Terraform"   = "true"
  }

}
