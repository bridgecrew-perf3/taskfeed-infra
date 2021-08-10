
provider "aws" {
  region = "us-east-2"

  endpoints {
    dynamodb = "http://localhost:8000"
  }
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

module "api_gateway" {
  source = "../modules/api_gateway"

  name                     = "taskfeed-rest-api"
  description              = "REST API for TaskFeed app."
  api_key_source           = "HEADER"
  openapi_spec             = "./files/taskfeed_spec_dev.yaml"
  api_endpoint_config_type = "REGIONAL"
  stage                    = "DEV"
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

}
