output "iam_policy_arn" {
  value = length(aws_iam_policy.main) > 0 ? aws_iam_policy.main[0].arn : null
}

output "iam_role_arn" {
  value = length(aws_iam_role.main) > 0 ? aws_iam_role.main[0].arn : null
}

output "function" {
  value = aws_lambda_function.main.arn
}

output "function_memory_size" {
  value = aws_lambda_function.main.memory_size
}

output "log_group" {
  value = aws_cloudwatch_log_group.main.arn
}
