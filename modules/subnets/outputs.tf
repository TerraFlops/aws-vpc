# ------------------------------------------------------------------------------------------------------------------------
# Public subnets
# ------------------------------------------------------------------------------------------------------------------------

output "public_subnets" {
  description = "Map of public route tables indexed by their identifier"
  value = tomap({
  for subnet_id, subnet in aws_subnet.public_subnets: subnet_id => subnet
  })
}

output "public_route_tables" {
  description = "Map of public route tables indexed by their identifier"
  value = tomap({
  for subnet_id, route_table in aws_route_table.public_subnets: subnet_id => route_table
  })
}

# ------------------------------------------------------------------------------------------------------------------------
# Private subnets
# ------------------------------------------------------------------------------------------------------------------------

output "private_subnets" {
  description = "Map of private subnets indexed by their identifier"
  value = tomap({
  for subnet_id, subnet in aws_subnet.private_subnets: subnet_id => subnet
  })
}

output "private_route_tables" {
  description = "Map of private route tables indexed by their identifier"
  value = tomap({
  for subnet_id, route_table in aws_route_table.private_subnets: subnet_id => route_table
  })
}
