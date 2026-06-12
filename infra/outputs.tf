# cognito
output "cognito_user_pool_id" {
  description = ""
  value = aws_cognito_user_pool.pool.id
}

output "cognito_user_pool_arn" {
  description = ""
  value = aws_cognito_user_pool.pool.arn
}

output "cognito_user_pool_client_id" {
  description = ""
  value = aws_cognito_user_pool_client.pool_client.id
}
