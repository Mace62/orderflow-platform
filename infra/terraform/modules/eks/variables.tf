variable "project" {
  description = "Project name used as to prefix the EKS resources"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster. Used for kubernetes.io/cluster/<cluster_name> tag"
  type        = string
}

variable "eks_version" {
  description = "The version of the EKS cluster"
  default     = "1.36"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "api_access" {
  description = "The API access configuration"
  type        = string
  validation {
    condition     = contains(["public", "private", "both"], var.api_access)
    error_message = "Invalid API access configuration. Valid values are public, private, both."
  }
}