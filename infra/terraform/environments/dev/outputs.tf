output "ecr_repository_urls" {
  description = "ECR repository URLs keyed by service name"
  value       = module.ecr.repository_urls
}

output "ecr_repository_names" {
  description = "ECR repository names keyed by service name"
  value       = module.ecr.repository_names
}

output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet ids"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet ids"
  value       = module.vpc.private_subnet_ids
}

output "cluster_name" {
  description = "Cluster name used for EKS / Karpenter subnet tags"
  value       = local.cluster_name
}

output "azs" {
  description = "Availability zones selected for this environment"
  value       = local.azs
}
