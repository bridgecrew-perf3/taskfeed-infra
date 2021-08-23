
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
