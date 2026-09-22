output "function_name" {
  description = "Nome da função lambda"
  value = aws_lambda_function.this.function_name
}

output "function_invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}

output "role_name" {
  value = aws_iam_role.this.name
}