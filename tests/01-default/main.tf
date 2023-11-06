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
  dir_name   = "01-default"
  aws_region = "us-west-1"
  name       = "terraform-test-${local.dir_name}"
}

provider "aws" {
  region = local.aws_region
}

module "main" {
  source                 = "../.."
  add_url                = true
  aws_account            = local.aws_account
  aws_region             = local.aws_region
  iac_source             = "terratest.fakehub.com"
  name                   = local.name
  runtime                = "go1.x"
  url_authorization_type = "NONE"
  source_file            = "tests/${local.dir_name}/hello"
  handler                = "hello"
}

data "aws_lambda_function" "existing" {
  depends_on    = [module.main]
  function_name = local.name
}

data "aws_cloudwatch_log_group" "existing" {
  depends_on = [module.main]
  name       = "lambda-${local.name}"
}

data "http" "test_function_url_response" {
  url = module.main.function_url
}

resource "test_assertions" "deploy_iam_policy_user_and_role" {
  component = "deploy_lambda_function_with_url"

  equal "policy_deployed" {
    description = "iam policy deployed"
    got         = module.main.iam_policy_arn
    want        = "arn:aws:iam::755285156183:policy/lambda-${local.name}"
  }

  equal "role_deployed" {
    description = "iam role deploy"
    got         = module.main.iam_role_arn
    want        = "arn:aws:iam::755285156183:role/lambda-${local.name}"
  }

  equal "function_deployed" {
    description = "lambda-${local.name} deploy"
    got         = data.aws_lambda_function.existing.arn
    want        = "arn:aws:lambda:us-west-1:755285156183:function:${local.name}"
  }

  equal "log_group_deployed" {
    description = "lambda-${local.name} log group deploy"
    got         = data.aws_cloudwatch_log_group.existing.arn
    want        = "arn:aws:logs:us-west-1:755285156183:log-group:lambda-${local.name}"
  }

  equal "function_has_a_url" {
    description = "lambda-${local.name} can be invoked via HTTPS"
    got         = data.http.test_function_url_response.response_body
    want        = "Hello from Lambda!"
  }
}
