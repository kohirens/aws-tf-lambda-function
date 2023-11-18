provider "aws" {
  region = "us-west-1"
}

variables {
  aws_region = "us-west-1"
  iac_source = "terratest.fakehub.com"
  name       = "terraform-test-01-default"
}

run "verify_all_lambda_function_pieces_deployed_with_default_values" {
  variables {
    runtime     = "go1.x"
    source_file = "tests/testdata/hello"
    handler     = "hello"
  }

  assert {
    condition     = aws_iam_policy.main[0].arn == "arn:aws:iam::${var.aws_account}:policy/lambda-terraform-test-01-default"
    error_message = "could not locate the policy to attach to the function IAM role"
  }

  assert {
    condition     = aws_iam_role.main[0].arn == "arn:aws:iam::${var.aws_account}:role/lambda-${var.name}"
    error_message = "lambda iam role was did not deploy"
  }

  assert {
    condition     = aws_lambda_function.main.arn == "arn:aws:lambda:${var.aws_region}:${var.aws_account}:function:${var.name}"
    error_message = "lambda did not deploy"
  }

  assert {
    condition     = aws_cloudwatch_log_group.main.arn == "arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:/aws/lambda/${var.name}"
    error_message = "lambda log group was not initialized"
  }
}
