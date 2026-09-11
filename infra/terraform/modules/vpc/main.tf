data "aws_region" "current" {}

locals {
  # One NAT Gateway for each az if "per_az", one total if "single", none if "none"
  nat_count = var.nat_mode == "per_az" ? length(var.azs) : (var.nat_mode == "single" ? 1 : 0)

  # The index of the NAT gateway to use for the private subnets
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

# --- Subnets -----------------------------------------------------------------

resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.project}-public-subnet-${var.azs[count.index]}"
    "kubernetes.io/role/elb"                    = "1" # tells the AWS LB controller to build internet-facing LBs here
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name                                        = "${var.project}-private-subnet-${var.azs[count.index]}"
    "kubernetes.io/role/internal-elb"           = "1" # internal LBs and the control-plane ENIs land here
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# --- NAT Gateways ------------------------------------------------------------

resource "aws_eip" "nat" {
  count  = local.nat_count
  domain = "vpc"

  tags = {
    Name = "${var.project}-nat-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "this" {
  count = local.nat_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project}-nat-gateway-${count.index}"
  }

  depends_on = [aws_internet_gateway.this]
}

# --- Route Tables ------------------------------------------------------------

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project}-public-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(var.azs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = length(var.azs)

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project}-private-route-table-${var.azs[count.index]}"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = var.nat_mode == "none" ? 0 : length(var.azs)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[local.private_nat_index[count.index]].id
}

resource "aws_route_table_association" "private" {
  count = length(var.azs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# --- Interface Endpoints -----------------------------------------------------

resource "aws_vpc_endpoint" "s3" {
    vpc_id = aws_vpc.this.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
    vpc_endpoint_type = "Gateway"
    route_table_ids = aws_route_table.private[*].id

    tags = {
        Name = "${var.project}-s3-endpoint"
    }
}

resource "aws_security_group" "endpoints" {
  count = length(var.interface_endpoints) > 0 ? 1 : 0

  name        = "${var.project}-endpoints"
  description = "HTTPS from within the VPC to interface endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTPS from the VPC CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-endpoints"
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each = toset(var.interface_endpoints)

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = aws_security_group.endpoints[*].id
  private_dns_enabled = true 

  tags = {
    Name = "${var.project}-${each.value}-endpoint"
  }
}