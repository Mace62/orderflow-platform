variable "project" {
  description = "Project name used as to prefix the EKS resources"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster. Used for kubernetes.io/cluster/<cluster_name> tag"
  type        = string
}

variable "cluster_version" {
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
  default     = "both"
  validation {
    condition     = contains(["public", "private", "both"], var.api_access)
    error_message = "Invalid API access configuration. Valid values are public, private, both."
  }
}

variable "public_access_cidrs" {
  description = "The CIDR blocks that are allowed to access the EKS cluster API"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_instance_types" {
    description = "The instance types of the nodes for the bootstrap group"
    type = list(string)
    default = ["t3.large"]
}

variable "node_min_size" {
    description = "The minimum number of nodes in the bootstrap group"
    type = number
    default = 2
}

variable "node_max_size" {
    description = "The maximum number of nodes in the bootstrap group"
    type = number
    default = 3
}

variable "node_desired_size" {
    description = "The desired number of nodes in the bootstrap group"
    type = number
    default = 2
}