terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.40.0, <5.0.0"
    }
  }
}

locals {
  aws_region  = "us-xmpl-1"
  aws_account = 100000000001
}

provider "aws" {
  region = local.aws_region
}

module "main" {
  source                 = "git@github.com:kohirens/aws-tf-lambda-function//.?ref=x.x.x"
  aws_account            = local.aws_account
  aws_region             = local.aws_region
  iac_source             = "https://git.example.com/my-iac"
  name                   = "my-function"
  runtime                = "go1.x"
  url_authorization_type = "NONE"
  source_file_name       = "hi"
}
