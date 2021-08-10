
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
