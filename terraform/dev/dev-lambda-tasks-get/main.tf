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
    key     = "dev/dev-lambda-tasks-get/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

locals {
  environment  = "Dev"
  organization = "TaskFeed"
}

module "lambda_func" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.11.0"

  function_name = "dev-tasks-get"

  handler = "index.lambda_handler"
  runtime = "python3.8"

  # Deploying initial dummy function
  create_package         = false
  local_existing_package = "./index.zip" # No changes should be made to the file

  # Disables deployments (managed via alt. pipeline)
  ignore_source_code_hash = true

  attach_policies    = true
  number_of_policies = 1 #  number of the policies listed below
  policies = [
    data.aws_iam_policy.dynamodb_read_only.arn
  ]

  tags = {
    "Organization" = local.organization
    "Environment"  = local.environment
    "Terraform"    = "true"
  }
}

# This policy may be too broad
data "aws_iam_policy" "dynamodb_read_only" {
  name = "AmazonDynamoDBReadOnlyAccess"
}
