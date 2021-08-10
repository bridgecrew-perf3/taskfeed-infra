output "api_gateway_id" {
  description = "The API identifier"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_gateway_arn" {
  description = "The API AWS resource arn"
  value       = aws_api_gateway_rest_api.this.arn
}

output "api_gateway_execution_arn" {
  description = "The API execution arn"
  value       = aws_api_gateway_deployment.this.execution_arn
}

output "api_gateway_url" {
  description = "The API url"
  value       = aws_api_gateway_deployment.this.invoke_url
}
