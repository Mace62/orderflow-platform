output "repository_names" {
  description = "Map of service name to ECR repository name"
  value       = { for k, r in aws_ecr_repository.this : k => r.name }
}

output "repository_arns" {
  description = "Map of service name to ECR repository ARN"
  value       = { for k, r in aws_ecr_repository.this : k => r.arn }
}

output "repository_urls" {
  description = "Map of service name to ECR repository URL (for docker push / task definitions)"
  value       = { for k, r in aws_ecr_repository.this : k => r.repository_url }
}
