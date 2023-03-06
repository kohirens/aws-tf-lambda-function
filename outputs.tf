output "iam_policy_arn" {
  value = length(aws_iam_policy.main) > 0 ? aws_iam_policy.main[0].arn : null
}

output "iam_role_arn" {
  value = length(aws_iam_role.main) > 0 ? aws_iam_role.main[0].arn : null
}