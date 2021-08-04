
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
