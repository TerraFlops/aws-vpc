# ------------------------------------------------------------------------------------------------------------------------
# VPC
# ------------------------------------------------------------------------------------------------------------------------

output "vpc" {
  description = "AWS VPC resource"
  value = aws_vpc.vpc
}

output "vpc_id" {
  description = "AWS VPC resource ID (e.g. vpc-2ca1fe97be4ef5)"
  value = aws_vpc.vpc.id
}

output "vpc_name" {
  description = "VPC name"
  value = aws_vpc.vpc.tags["Name"]
}

output "vpc_description" {
  description = "VPC description"
  value = lookup(aws_vpc.vpc.tags, "Description", null)
}

# ------------------------------------------------------------------------------------------------------------------------
# Subnets
# ------------------------------------------------------------------------------------------------------------------------

output "subnets" {
  description = "Map of all subnet AWS resources indexed by the Terraform identifier"
  value = local.output_subnets
}

output "subnet_ids" {
  description = "Map of all subnet CIDR AWS resource IDs indexed by the Terraform identifier (e.g. {'public_subnet_2a' = 'subnet-2ca1fe97be4ef5'})"
  value = tomap({
    for subnet_id, subnet in local.output_subnets: subnet_id => local.output_subnets[subnet_id]["id"]
  })
}

# ------------------------------------------------------------------------------------------------------------------------
# CIDR blocks
# ------------------------------------------------------------------------------------------------------------------------

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value = aws_vpc.vpc.cidr_block
}

output "subnet_cidr_blocks" {
  description = "Map of all subnet CIDR blocks indexed by the Terraform identifier (e.g. {'public_subnet_2b' = '10.0.11.0/24'})"
  value = tomap({
    for subnet_id, subnet in local.output_subnets: subnet_id => local.output_subnets[subnet_id]["cidr_block"]
  })
}

# ------------------------------------------------------------------------------------------------------------------------
# Route tables
# ------------------------------------------------------------------------------------------------------------------------

output "route_tables" {
  description = "Map of all route table AWS resources indexed by the Terraform identifier"
  value = tomap({
    for route_table_id, route_table in local.output_route_tables: route_table_id => local.output_route_tables[route_table_id]
  })
}

output "route_table_ids" {
  description = "Map of all route table AWS resource IDs indexed by the Terraform identifier (e.g. {'public_subnet_2a' = 'rtb-2ca1fe97be4ef5'})"
  value = tomap({
    for route_table_id, route_table in local.output_route_tables: route_table_id => local.output_route_tables[route_table_id]["id"]
  })
}

# ------------------------------------------------------------------------------------------------------------------------
# Internet gateway
# ------------------------------------------------------------------------------------------------------------------------

output "internet_gateway" {
  description = "If an Internet Gateway was created this will contain the AWS resource, otherwise the value will be null"
  value = var.internet_gateway_enabled == true ? aws_internet_gateway.internet_gateway[0] : null
}

output "internet_gateway_id" {
  description = "If an Internet Gateway was created this will contain its AWS resource ID, otherwise the value will be null"
  value = var.internet_gateway_enabled == true ? aws_internet_gateway.internet_gateway[0].id : null
}

output "internet_gateway_arn" {
  description = "If an Internet Gateway was created this will contain its ARN, otherwise the value will be null"
  value = var.internet_gateway_enabled == true ? aws_internet_gateway.internet_gateway[0].arn : null
}

# ------------------------------------------------------------------------------------------------------------------------
# Security groups
# ------------------------------------------------------------------------------------------------------------------------

output "security_groups" {
  description = "Map of all security group AWS resources indexed by the Terraform identifier"
  value = tomap({
    for id, description in var.security_groups: id => module.security_groups.security_groups[id]
    if contains(keys(module.security_groups.security_group_ids), id)
  })
}

output "security_group_ids" {
  description = "Map of all security group AWS resources IDs indexed by the Terraform identifier"
  value = tomap({
    for id, description in var.security_groups: id => module.security_groups.security_group_ids[id]
    if contains(keys(module.security_groups.security_group_ids), id)
  })
}

output "security_group_arns" {
  description = "Map of all security group AWS resources ARNs indexed by the Terraform identifier"
  value = tomap({
    for id, description in var.security_groups: id => module.security_groups.security_group_arns[id]
    if contains(keys(module.security_groups.security_group_ids), id)
  })
}
