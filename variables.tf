variable "architecture" {
  default     = "x86_64"
  description = "Instruction set architecture for your Lambda function. Valid values are x86_64, arm64."
}

variable "aws_account" {
  description = "AWS account id"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "description" {
  default     = null
  description = "Provide a description"
}

variable "iac_source" {
  description = "URL where the code lives."
  type        = string
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

variable "runtime" {
  description = "Identifier of the function's runtime. See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
  type        = string
}

variable "url_alias" {
  default     = null
  description = ""
  type        = string
}

variable "url_allowed_methods" {
  default     = ["GET"]
  description = "List of HTTP methods allowed."
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