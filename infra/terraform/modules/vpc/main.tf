data "aws_region" "current" {}

locals {
  # One NAT Gateway for each az if "per_az", one total if "single", none if "none"
  nat_count = var.nat_mode == "per_az" ? length(var.azs) : (var.nat_mode == "single" ? 1 : 0)

  private_nat_index = var.nat_mode == "per_az" ? range(length(var.azs)) : [for i in range(length(var.azs)) : 0]
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project}-igw"
  }
}
