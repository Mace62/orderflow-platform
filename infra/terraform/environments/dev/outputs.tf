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

output "azs" {
  description = "Availability zones selected for this environment"
  value       = local.azs
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "oidc_issuer_url" {
  description = "Hand this to the IRSA session next week."
  value       = module.eks.oidc_issuer_url
}

output "node_role_arn" {
  description = "Karpenter reuses this node role later."
  value       = module.eks.node_role_arn
}

output "update_kubeconfig" {
  description = "Copy-paste this to point kubectl at the new cluster."
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}
