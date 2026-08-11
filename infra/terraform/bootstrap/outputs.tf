output "state_bucket_name" {
  description = "S3 bucket for Terraform remote state (use in other stacks' backend config)"
  value       = aws_s3_bucket.tfstate.id
}

output "state_bucket_arn" {
  description = "ARN of the Terraform state bucket"
  value       = aws_s3_bucket.tfstate.arn
}

output "state_bucket_region" {
  description = "Region of the Terraform state bucket"
  value       = aws_s3_bucket.tfstate.region
}
