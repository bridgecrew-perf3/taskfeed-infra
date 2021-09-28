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
    key     = "dev/dev-vpc/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

locals {
  region = "us-east-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "taskfeed-dev-vpc"
  cidr = "10.71.0.0/16" # largest cidr block allowed by AWS

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets  = ["10.71.1.0/24", "10.71.2.0/24", "10.71.3.0/24"]
  public_subnets   = ["10.71.11.0/24", "10.71.12.0/24", "10.71.13.0/24"]
  database_subnets = ["10.71.21.0/24", "10.71.22.0/24", "10.71.23.0/24"]

  create_database_subnet_group = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dhcp_options = true

  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
}
