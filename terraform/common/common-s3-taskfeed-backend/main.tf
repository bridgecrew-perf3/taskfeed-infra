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
    key     = "common/common-s3-taskfeed-backend/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

locals {
  region      = "us-east-2"
  environment = "Dev"
}

module "s3_bucket_backend" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2.7.0"

  bucket        = "taskfeed-backend"
  acl           = "private"
  force_destroy = true

  versioning = {
    enabled = true
  }

  tags = {
    "Environment" = local.environment
    "Terraform"   = "true"
  }
}
