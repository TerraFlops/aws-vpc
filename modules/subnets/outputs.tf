# ------------------------------------------------------------------------------------------------------------------------
# Public subnets
# ------------------------------------------------------------------------------------------------------------------------

output "public_subnets" {
  description = "Map of public route tables indexed by their identifier"
  value = tomap({
    for subnet_id, subnet in aws_subnet.public_subnets: subnet_id => subnet
    if contains(keys(aws_subnet.public_subnets), subnet_id)
  })
}

output "public_subnet_ids" {
  value = tomap({
    for name, subnet in var.public_subnets: name => aws_subnet.public_subnets[name].id
    if contains(keys(aws_subnet.public_subnets), name)
  })
}

output "public_subnet_arns" {
  value = tomap({
    for name, subnet in var.public_subnets: name => aws_subnet.public_subnets[name].arn
    if contains(keys(aws_subnet.public_subnets), name)
  })
}


output "public_route_tables" {
  description = "Map of public route tables indexed by their identifier"
  value = tomap({
    for subnet_id, route_table in aws_route_table.public_subnets: subnet_id => route_table
    if contains(keys(aws_route_table.public_subnets), subnet_id)
  })
}

output "public_route_table_ids" {
  value = tomap({
    for name, route_table in var.public_subnets: name => aws_route_table.public_subnets[name].id
    if contains(keys(aws_route_table.public_subnets), name)
  })
}

# ------------------------------------------------------------------------------------------------------------------------
# Private subnets
# ------------------------------------------------------------------------------------------------------------------------

output "private_subnets" {
  description = "Map of private subnets indexed by their identifier"
  value = tomap({
    for subnet_id, subnet in aws_subnet.private_subnets: subnet_id => subnet
    if contains(keys(aws_subnet.private_subnets), subnet_id)
  })
}

output "private_subnet_ids" {
  value = tomap({
    for name, subnet in var.private_subnets: name => aws_subnet.private_subnets[name].id
    if contains(keys(aws_subnet.private_subnets), name)
  })
}

output "private_subnet_arns" {
  value = tomap({
    for name, subnet in var.private_subnets: name => aws_subnet.private_subnets[name].arn
    if contains(keys(aws_subnet.private_subnets), name)
  })
}

output "private_route_tables" {
  description = "Map of private route tables indexed by their identifier"
  value = tomap({
  for subnet_id, route_table in aws_route_table.private_subnets: subnet_id => route_table
    if contains(keys(aws_route_table.private_subnets), subnet_id)
  })
}

output "private_route_table_ids" {
  value = tomap({
    for name, route_table in var.private_subnets: name => aws_route_table.private_subnets[name].id
    if contains(keys(aws_route_table.private_subnets), name)
  })
}
