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
