terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    http = {
      source = "hashicorp/http"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">=3.40.0, <5.0.0"
    }
  }
}

locals {
  aws_region = "us-west-1"
}

provider "aws" {
  region = local.aws_region
}

module "main" {
  source                 = "../.."
  aws_account            = local.aws_account
  aws_region             = local.aws_region
  iac_source             = "terratest.fakehub.com"
  name                   = "terraform-test"
  runtime                = "go1.x"
  url_authorization_type = "NONE"
  source_file            = "tests/default/hello"
  handler                = "hello"
}

resource "test_assertions" "deploy_iam_policy_user_and_role" {
  component = "deploy_iam_policy_user_and_role"

  equal "policy_deployed" {
    description = "iam policy deployed"
    got         = module.main.iam_policy_arn
    want        = "arn:aws:iam::755285156183:policy/lambda-terraform-test-policy"
  }

  equal "role_deployed" {
    description = "iam role deploy"
    got         = module.main.iam_role_arn
    want        = "arn:aws:iam::755285156183:role/lambda-terraform-test-role"
  }
}
