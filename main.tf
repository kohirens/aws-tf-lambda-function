locals {
  module_name = "lambda-function"

  tags = {
    module-name = local.module_name
    iac-source  = var.iac_source
  }

  policy_path = var.policy_path != null ? var.policy_path : "${path.module}/files/function-iam-role-policy.json"
  policy_doc = templatefile(local.policy_path, {
    region           = var.aws_region
    account_id       = var.aws_account
    lambda_func_name = var.name
  })
}

resource "aws_iam_policy" "main" {
  count  = var.role_arn == null ? 1 : 0
  name   = "lambda-${var.name}-policy"
  policy = local.policy_doc
}

resource "aws_iam_role" "main" {
  count                 = var.role_arn == null ? 1 : 0
  description           = "lambda ${var.name} function role"
  force_detach_policies = true
  name                  = "lambda-${var.name}-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "main" {
  policy_arn = aws_iam_policy.main[0].arn
  role       = aws_iam_role.main[0].name
}

#resource "aws_lambda_function" "main" {
#  authorization_type = "NONE"
#  architectures      = var.architecture
#  function_name      = var.name
#  role               = var.role_arn
#  runtime            = var.runtime
#
#  depends_on = [
#    aws_iam_role_policy_attachment.lambda_logs,
#    aws_cloudwatch_log_group.example,
#  ]
#}
#
#resource "aws_lambda_function_url" "main" {
#  function_name      = aws_lambda_function.main.function_name
#  qualifier          = var.url_alias
#  authorization_type = var.url_authorization_type
#
#  cors {
#    allow_credentials = true
#    allow_origins     = ["*"]
#    allow_methods     = var.url_allowed_methods
##    allow_headers     = ["date", "keep-alive"]
##    expose_headers    = ["keep-alive", "date"]
#    max_age           = var.url_max_age
#  }
#}