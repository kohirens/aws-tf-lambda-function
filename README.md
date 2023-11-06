# Lambda Function Terraform Module

## Status Badge

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/kohirens/aws-tf-lambda-function/tree/main.svg?style=svg&circle-token=ac24e63ddc40ab9086688c56e660e74fb70ad1ed)](https://dl.circleci.com/status-badge/redirect/gh/kohirens/aws-tf-lambda-function/tree/main)

## Resources

Deploys the following resources:
* An IAM Managed policy
* An IAM Role
* A CloudWatch log group
* A Lambda function (URL optional)

## Experimental Test

This uses the HashiCorp experimental `test` feature. 

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.3.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.57.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_url.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_url"></a> [add\_url](#input\_add\_url) | Allow invoking the Lambda function via HTTPS. See https://aws.amazon.com/blogs/aws/announcing-aws-lambda-function-urls-built-in-https-endpoints-for-single-function-microservices/ | `bool` | `false` | no |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | Instruction set architecture for your Lambda function. Valid values are x86\_64 or arm64. | `string` | `"x86_64"` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS account id. | `number` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy the function. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Function description. | `string` | `null` | no |
| <a name="input_environment_vars"></a> [environment\_vars](#input\_environment\_vars) | Key value pairs to add to Lambda function environment. | `map(string)` | `null` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | Name of the function that serves as the entrypoint in your code (or the name of the executable for binaries). | `string` | n/a | yes |
| <a name="input_iac_source"></a> [iac\_source](#input\_iac\_source) | URL where the code lives. | `string` | n/a | yes |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0 they never expire. | `number` | `14` | no |
| <a name="input_name"></a> [name](#input\_name) | Lambda function name. | `string` | n/a | yes |
| <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path) | Path to a IAM policy. | `string` | `null` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits. | `string` | `-1` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | ARN for the function to assume, this will be used instad of making a new role. | `string` | `null` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Identifier of the function's runtime. See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime | `string` | n/a | yes |
| <a name="input_source_file"></a> [source\_file](#input\_source\_file) | a file to zip up for your Lambda. Works well apps that build to a single binary. | `string` | `null` | no |
| <a name="input_source_zip"></a> [source\_zip](#input\_source\_zip) | Supply your own zip for he Lambda. | `string` | `null` | no |
| <a name="input_url_alias"></a> [url\_alias](#input\_url\_alias) | n/a | `string` | `null` | no |
| <a name="input_url_allowed_headers"></a> [url\_allowed\_headers](#input\_url\_allowed\_headers) | HTTP headers allowed. | `list(string)` | <pre>[<br>  "date",<br>  "keep-alive"<br>]</pre> | no |
| <a name="input_url_allowed_methods"></a> [url\_allowed\_methods](#input\_url\_allowed\_methods) | List of HTTP verbs allowed. | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_url_allowed_origins"></a> [url\_allowed\_origins](#input\_url\_allowed\_origins) | List of HTTP methods allowed. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_url_authorization_type"></a> [url\_authorization\_type](#input\_url\_authorization\_type) | Valid values are NONE and AWS\_IAM. | `string` | `"AWS_IAM"` | no |
| <a name="input_url_headers_to_expose"></a> [url\_headers\_to\_expose](#input\_url\_headers\_to\_expose) | List of HTTP headers to expose in te response. | `list(string)` | <pre>[<br>  "keep-alive",<br>  "date"<br>]</pre> | no |
| <a name="input_url_max_age"></a> [url\_max\_age](#input\_url\_max\_age) | The maximum amount of time, in seconds, that web browsers can cache results of a preflight request. The maximum value is 86400. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | n/a |
| <a name="output_function_memory_size"></a> [function\_memory\_size](#output\_function\_memory\_size) | n/a |
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | n/a |
| <a name="output_iam_policy_arn"></a> [iam\_policy\_arn](#output\_iam\_policy\_arn) | n/a |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | n/a |
| <a name="output_log_group"></a> [log\_group](#output\_log\_group) | n/a |
<!-- END_TF_DOCS -->
