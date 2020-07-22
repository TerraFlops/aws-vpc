# ------------------------------------------------------------------------------------------------------------------------
# Native NAT Gateway component
# ------------------------------------------------------------------------------------------------------------------------

# It is recommended that NAT gateways are used in production environments, and EC2 NAT instances are used in non-production
# environments for cost savings

locals {
  # Create map of all public subnets (those which route directly to the internet gateway)
  subnets_public_nat_gateway = tomap({
  for subnet in local.subnets_array:
  replace(subnet["subnet_name"], "-", "_") => subnet
  if subnet["subnet_type"] == var.internet_gateway && var.nat_gateway_enabled == true
  })

  # Create map of all private subnets (those which do not route directly to the internet gateway)
  subnets_private_nat_gateway = tomap({
  for subnet in local.subnets_array:
  replace(subnet["subnet_name"], "-", "_") => subnet
  if subnet["subnet_type"] != var.internet_gateway && var.nat_gateway_enabled == true
  })
}

# Create an Elastic IP for each NAT gateway that will be created
resource "aws_eip" "nat_gateway_eip" {
  for_each = local.subnets_public_nat_gateway
  vpc = true
  tags = {
    Name = "${aws_subnet.subnets[each.key].tags["Name"]}-nat-gateway-eip"
  }
}

# Create a NAT gateway in each of the public subnets
resource "aws_nat_gateway" "nat_gateway" {
  for_each = local.subnets_public_nat_gateway
  subnet_id = aws_subnet.subnets[each.key].id
  # Link the NAT gateway to
  allocation_id = aws_eip.nat_gateway_eip[each.key].id
  tags = {
    Name = "${aws_subnet.subnets[each.key].tags["Name"]}-nat-gateway"
    # There may be a better way to do this- but for now this tag will be used below when creating routes
    # from private subnets back to this NAT gateway
    AvailabilityZone = aws_subnet.subnets[each.key].tags["AvailabilityZone"]
  }
}

# Create a route in each private subnet back to the appropriate NAT gateway
resource "aws_route" "route_nat_gateway" {
  for_each = local.subnets_private_nat_gateway
  route_table_id = aws_route_table.route_tables[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  # There may be a better way to do this- but for now we are matching the private subnet to the public
  # subnet using the 'AvailabilityZone' tag that we created above
  nat_gateway_id = [
  for nat_gateway in aws_nat_gateway.nat_gateway: nat_gateway.id
  if nat_gateway.tags["AvailabilityZone"] == aws_subnet.subnets[each.key].tags["AvailabilityZone"]
  ][0]
}
