output "iam_policy_arn" {
  value = length(aws_iam_policy.main) > 0 ? aws_iam_policy.main[0].arn : null
}

output "iam_role_arn" {
  value = length(aws_iam_role.main) > 0 ? aws_iam_role.main[0].arn : null
}

output "function_arn" {
  value = aws_lambda_function.main.arn
}

output "function_memory_size" {
  value = aws_lambda_function.main.memory_size
}

output "function_url" {
  value = length(aws_lambda_function_url.main) > 0 ? aws_lambda_function_url.main[0].function_url : null
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.main.arn
}
