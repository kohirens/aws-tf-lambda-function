variable "add_url" {
  default     = false
  description = "Allow invoking the Lambda function via HTTPS. See https://aws.amazon.com/blogs/aws/announcing-aws-lambda-function-urls-built-in-https-endpoints-for-single-function-microservices/"
  type        = bool
}

variable "architecture" {
  default     = "x86_64"
  description = "Instruction set architecture for your Lambda function. Valid values are x86_64 or arm64."
  type        = string

  validation {
    condition     = var.architecture == "x86_64" || var.architecture == "arm64"
    error_message = "value MUST be either \"x86_64\" or \"arm64\""
  }
}

variable "aws_account" {
  description = "AWS account id."
  type        = number
}

variable "aws_region" {
  description = "AWS region to deploy the function."
  type        = string
}

variable "description" {
  default     = null
  description = "Function description."
  type        = string
}

variable "environment_vars" {
  default     = null
  description = "Key value pairs to add to Lambda function as environment variables."
  type        = map(string)
}

variable "handler" {
  description = "Name of the function that serves as the entrypoint in your code (or the name of the executable for binaries)."
  type        = string
}

variable "iac_source" {
  description = "URL where the code lives."
  type        = string
}

variable "log_retention_in_days" {
  default     = 14
  description = "Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0 they never expire."
  type        = number
}

variable "name" {
  description = "Lambda function name."
  type        = string
}

variable "policy_path" {
  default     = null
  description = "Path to a IAM policy."
  type        = string
}
variable "role_arn" {
  default     = null
  description = "ARN for the function to assume, this will be used instad of making a new role."
  type        = string
}

variable "reserved_concurrent_executions" {
  default     = -1
  description = "Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits."
  type        = string
}

variable "runtime" {
  description = "Identifier of the function's runtime. See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
  type        = string
}

variable "source_file" {
  default     = null
  description = "a file to zip up for your Lambda. Works well apps that build to a single binary."
  type        = string
}

variable "source_zip" {
  default     = null
  description = "Supply your own zip for he Lambda."
  type        = string
}

variable "url_alias" {
  default     = null
  description = ""
  type        = string
}

variable "url_allowed_headers" {
  default     = ["date", "keep-alive"]
  description = "HTTP headers allowed."
  type        = list(string)
}

variable "url_allowed_methods" {
  default     = ["GET", "HEAD"]
  description = "List of HTTP verbs allowed."
  type        = list(string)
}

variable "url_headers_to_expose" {
  default     = ["keep-alive", "date"]
  description = "List of HTTP headers to expose in te response."
  type        = list(string)
}

variable "url_allowed_origins" {
  default     = ["*"]
  description = "List of HTTP methods allowed."
  type        = list(string)
}

variable "url_authorization_type" {
  default     = "AWS_IAM"
  description = "Valid values are NONE and AWS_IAM."
  type        = string
}

variable "url_max_age" {
  default     = 0
  description = "The maximum amount of time, in seconds, that web browsers can cache results of a preflight request. The maximum value is 86400."
  type        = number
}