variable "project" {
  description = "Project name used as to prefix the VPC resources"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster. Used for kubernetes.io/cluster/<cluster_name> tag"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "The availability zones to spread the subnets across"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "nat_mode" {
  description = "The NAT mode to use for the VPC. none = endpoint oinly, single = single NAT gateway, per_az = one NAT gateway per availability zone"
  type        = string
  default     = "single"

  validation {
    condition     = contains(["none", "single", "per_az"], var.nat_mode)
    error_message = "Invalid NAT mode. Valid values are none, single, per_az."
  }
}

variable "interface_endpoints" {
  description = "A list of interface endpoints to create, S3 created regardless"
  type        = list(string)
  default = []
  # default = [
  #   "ecr.api",
  #   "ecr.dkr",
  #   "sts",
  #   "ssm",
  #   "ssmmessages",
  #   "ec2messages",
  #   "secretsmanager",
  #   "logs",
  # ]
} 