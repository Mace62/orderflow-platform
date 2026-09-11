# Prefer zones that don't require opt-in (portable across accounts/regions).
data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  services = [
    "api-gateway",
    "order-service",
    "inventory-service",
    "payment-service",
    "notification-service",
    "shipping-service",
    "worker",
    "scheduler",
    "dashboard-api",
  ]

  cluster_name = "${var.project}-${var.environment}"
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source = "../../modules/vpc"

  project      = var.project
  cluster_name = local.cluster_name
  cidr_block   = var.vpc_cidr
  azs          = local.azs
  nat_mode     = var.nat_mode

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "ecr" {
  source = "../../modules/ecr"

  project      = var.project
  services     = local.services
  force_delete = var.ecr_force_delete

  tags = {
    Environment = var.environment
  }
}
