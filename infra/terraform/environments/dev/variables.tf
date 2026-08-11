variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "project" {
  description = "Project name used for resource naming"
  type        = string
  default     = "orderflow"
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "ecr_force_delete" {
  description = "Allow destroying ECR repos that still contain images (useful in dev)"
  type        = bool
  default     = true
}
