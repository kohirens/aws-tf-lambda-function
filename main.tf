locals {
  module_name    = "lambda-function"
  new_role_count = var.role_arn == null ? 1 : 0

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
  count  = local.new_role_count
  name   = "lambda-${var.name}-policy"
  policy = local.policy_doc
}

resource "aws_iam_role" "main" {
  count                 = local.new_role_count
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
  count      = local.new_role_count
  policy_arn = aws_iam_policy.main[0].arn
  role       = aws_iam_role.main[0].name
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "lambda-${var.name}"
  retention_in_days = var.log_retention_in_days
  tags              = local.tags
}

data "archive_file" "lambda_zip" {
  count       = var.source_zip == null ? 1 : 0
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source_file = var.source_file
}

resource "aws_lambda_function" "main" {
  architectures = var.architecture
  filename      = var.source_zip != null ? var.source_zip : data.archive_file.lambda_zip[0].output_path
  function_name = var.name
  handler       = var.handler
  role          = var.role_arn != null ? var.role_arn : aws_iam_role.main[0].arn
  runtime       = var.runtime


  depends_on = [
    aws_iam_role_policy_attachment.main[0],
    aws_cloudwatch_log_group.main,
  ]
}

# see: https://aws.amazon.com/blogs/aws/announcing-aws-lambda-function-urls-built-in-https-endpoints-for-single-function-microservices/
# also: https://docs.aws.amazon.com/lambda/latest/dg/configuration-aliases.html#configuration-aliases-config
resource "aws_lambda_function_url" "main" {
  count              = var.add_url ? 1 : 0
  function_name      = aws_lambda_function.main.function_name
  qualifier          = var.url_alias
  authorization_type = var.url_authorization_type

  cors {
    allow_credentials = true
    allow_origins     = var.url_allowed_origins
    allow_methods     = var.url_allowed_methods
    allow_headers     = var.url_allowed_headers
    expose_headers    = var.url_headers_to_expost
    max_age           = var.url_max_age
  }
}