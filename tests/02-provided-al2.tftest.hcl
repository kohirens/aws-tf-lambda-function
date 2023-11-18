provider "aws" {
  region = "us-west-1"
}

variables {
  aws_region = "us-west-1"
  iac_source = "terratest.fakehub.com"
  name       = "terraform-test-02-provided-al2-url"
}

run "execute" {
  variables {
    add_url                = true
    architecture           = "arm64"
    aws_account            = var.aws_account
    runtime                = "provided.al2"
    url_authorization_type = "NONE"
    source_zip             = "tests/testdata/bootstrap.zip"
    handler                = "bootstrap"
  }
}

run "verify_function_url_with_arm64_al2_go_runtime" {
  module {
    source = "./tests/02-provided-al2"
  }

  variables {
    url = run.execute.function_url
  }
  assert {
    condition     = data.http.test_function_url_response.response_body == "Hello from Lambda!"
    error_message = "lambda function ${var.name} cannot be invoked via HTTPS"
  }
}