output "ecr_repository_urls" {
  description = "ECR repository URLs keyed by service name"
  value       = module.ecr.repository_urls
}

output "ecr_repository_names" {
  description = "ECR repository names keyed by service name"
  value       = module.ecr.repository_names
}
