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
    key     = "dev/dev-rds-mysql/terraform.tfstate"
    region  = "us-east-2"
    encrypt = true
  }
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.db_creds.secret_string
  )
}

# Secrets manually created on AWS console
data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = "taskfeed-rds-mysql-dev-credentials"
}

# Default VPC
data "aws_vpc" "defaut_vpc" {
  default = true
}

data "aws_subnet_ids" "default_vpc_subnet" {
  vpc_id = data.aws_vpc.defaut_vpc.id
}

module "rds-mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "taskfeed-rds-myslq-dev"

  engine               = "mysql"
  engine_version       = "8.0.25"
  major_engine_version = "8.0"
  instance_class       = "db.t2.micro"

  storage_type      = "gp2"
  allocated_storage = 20

  name = "taskfeedRDSMySQLDev"
  # Set the secrets from AWS Secrets Manager
  username            = local.db_creds.username
  password            = local.db_creds.password
  port                = 3306
  publicly_accessible = true #DEV ONLY

  multi_az   = true
  subnet_ids = data.aws_subnet_ids.default_vpc_subnet.ids
  ## Not so important for dev but we should be deploying to our own vpc
  #subnet_ids             = module.vpc.database_subnets
  #vpc_security_group_ids = [module.security_group.security_group_id]

  backup_retention_period = 7
  backup_window           = "03:00-06:00"

  # Sticking to defaults for dev env
  create_db_option_group    = false
  create_db_parameter_group = false

}
