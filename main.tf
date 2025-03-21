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
    account_no       = var.aws_account
    lambda_func_name = var.name
  })

  environment = [var.environment_vars]

  // template variable map
  tmpl_vars = merge({
    account_no       = var.aws_account
    region           = var.aws_region
    lambda_func_name = var.name
    lambda_func_arn  = aws_lambda_function.main.arn
  }, var.additional_policies_template_vars)

  policy_docs = {
    for k, policy in var.additional_policies :
    k => templatefile("${path.module}/${policy}", local.tmpl_vars)
  }
}

resource "aws_iam_policy" "main" {
  count  = local.new_role_count
  name   = "lambda-${var.name}"
  policy = local.policy_doc
}

resource "aws_iam_role" "main" {
  count                 = local.new_role_count
  description           = "lambda ${var.name} function role"
  force_detach_policies = true
  name                  = "lambda-${var.name}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "edgelambda.amazonaws.com",
            "lambda.amazonaws.com"
          ]
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

# There is NO WAY to specify a different log group name, it must match this
# pattern /aws/lambda/<function_name>. The function will only write to this
# and must have permission to make it when it does not exists.
# See: https://docs.aws.amazon.com/lambda/latest/dg/monitoring-cloudwatchlogs.html
# Also: https://repost.aws/questions/QUF4zgK1TBQlqb6WvYF1DXaQ/group-lambda-logs
resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${var.name}"
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
  depends_on = [
    aws_iam_role_policy_attachment.main[0],
    aws_cloudwatch_log_group.main,
  ]

  architectures                  = [var.architecture]
  description                    = var.description
  filename                       = var.source_zip != null ? var.source_zip : data.archive_file.lambda_zip[0].output_path
  function_name                  = var.name
  handler                        = var.handler
  role                           = var.role_arn != null ? var.role_arn : aws_iam_role.main[0].arn
  runtime                        = var.runtime
  reserved_concurrent_executions = var.reserved_concurrent_executions
  source_code_hash               = var.source_zip != null ? filebase64sha256(var.source_zip) : filebase64sha256(data.archive_file.lambda_zip[0].output_path)

  dynamic "environment" {
    for_each = local.environment
    content {
      variables = environment.value
    }
  }
}

# see: https://aws.amazon.com/blogs/aws/announcing-aws-lambda-function-urls-built-in-https-endpoints-for-single-function-microservices/
# also: https://docs.aws.amazon.com/lambda/latest/dg/configuration-aliases.html#configuration-aliases-config
resource "aws_lambda_function_url" "main" {
  count = var.add_url ? 1 : 0

  authorization_type = var.url_authorization_type
  invoke_mode        = var.invoke_mode
  function_name      = aws_lambda_function.main.function_name
  qualifier          = var.url_alias

  cors {
    allow_credentials = true
    allow_origins     = var.url_cors_allowed_origins
    allow_methods     = var.url_cors_allowed_methods
    allow_headers     = var.url_cors_allowed_headers
    expose_headers    = var.url_cors_headers_to_expose
    max_age           = var.url_cors_max_age
  }
}

resource "aws_iam_policy" "policy" {
  for_each    = var.additional_policies
  name        = each.key
  path        = "/"
  description = "Lambda function ${var.name} policy."

  policy = local.policy_docs[each.key]
}

# Attach additional policies to the Lambda execution role when this module
# deploys the role.
resource "aws_iam_role_policy_attachment" "added_policies" {
  for_each   = local.new_role_count > 0 ? aws_iam_policy.policy : {}
  policy_arn = each.value.arn
  role       = aws_iam_role.main[0].name
}

# Add a resource policy to the Lambda function to allow an external source (like an EventBridge Rule, SNS, S3, or CloudFront).
resource "aws_lambda_permission" "resource_policies" {
  for_each      = var.resource_policies
  depends_on    = [aws_lambda_function.main]
  statement_id  = each.key
  action        = each.value.action
  principal     = each.value.principal
  function_name = var.name
  source_arn    = each.value.source_arn
}