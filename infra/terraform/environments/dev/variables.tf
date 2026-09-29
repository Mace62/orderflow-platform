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
  description = "Allow destroying ECR repos that still contain images"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs, one per AZ (/24)"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs, one per AZ (/19)"
  type        = list(string)
  default     = ["10.0.32.0/19", "10.0.64.0/19", "10.0.96.0/19"]
}

variable "nat_mode" {
  description = "NAT topology: none, single (dev default), or per_az"
  type        = string
  default     = "single"
}

variable "admin_principal_arns" {
  description = "The ARNs of the admin which can access the EKS cluster"
  type        = list(string)
  default     = []
}

variable "public_access_cidrs" {
  description = "The CIDR blocks that are allowed to access the EKS cluster API"
  type        = list(string)
}