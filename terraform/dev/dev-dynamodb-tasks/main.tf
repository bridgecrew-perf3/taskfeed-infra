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
    key     = "dev/dev-dynamodb-tasks/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

locals {
  environment  = "Dev"
  organization = "TaskFeed"
}

# Table structrure:
#   user_id: S (partition)
#   task_is: S (partition)
#   date_created: N
#   status: S (later, now, done)
#   deadline: N
#   weight: S (easy, medium, hard)
module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 1.1.0"

  name = "tasks"

  # Keep at provisioned to ensure we don't spend money on dev
  billing_mode = "PROVISIONED"

  # Temp values
  read_capacity  = 5
  write_capacity = 5

  # Combination of primary(hash) and sort(range) key to produce unique id 
  hash_key  = "user_id"
  range_key = "task_id"

  # Only hash/sort key required to be listed below
  attributes = [
    {
      name = "user_id"
      type = "S"
    },
    {
      name = "task_id"
      type = "S"
    }
  ]

  tags = {
    "Organization" = local.organization
    "Environment"  = local.environment
    "Terraform"    = "true"
  }

}
