output "vpc_id" {
  description = "The VPC id."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR."
  value       = aws_vpc.this.cidr_block
}

output "azs" {
  description = "Availability zones used for subnets."
  value       = var.azs
}

output "public_subnet_ids" {
  description = "Public subnet ids, one per AZ. Feed these to the NLB / internet-facing load balancers."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet ids, one per AZ. Feed these to the EKS cluster, nodes, and Karpenter."
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
  description = "NAT gateway ids. Empty when nat_mode is none."
  value       = aws_nat_gateway.this[*].id
}

output "interface_endpoint_ids" {
  description = "Map of interface endpoint service short name to endpoint id."
  value       = { for k, v in aws_vpc_endpoint.interface : k => v.id }
}

output "s3_endpoint_id" {
  description = "S3 gateway VPC endpoint id."
  value       = aws_vpc_endpoint.s3.id
}

output "endpoints_security_group_id" {
  description = "Security group id attached to interface endpoints. Null when no interface endpoints are enabled."
  value       = try(aws_security_group.endpoints[0].id, null)
}
