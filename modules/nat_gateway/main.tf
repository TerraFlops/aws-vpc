# ------------------------------------------------------------------------------------------------------------------------
# Retrieve AWS resources
# ------------------------------------------------------------------------------------------------------------------------

data "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_ids)
  id = var.public_subnet_ids[count.index]
  vpc_id = var.vpc_id
}

data "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_ids)
  id = var.public_subnet_ids[count.index]
  vpc_id = var.vpc_id
}

data "aws_route_table" "private_subnets" {
  count = length(var.private_subnet_ids)
  vpc_id = var.vpc_id
  subnet_id = var.private_subnet_ids[count.index]
}

# Create an Elastic IP for each NAT gateway that will be created
resource "aws_eip" "nat_gateway_eip" {
  count = length(var.public_subnet_ids)
  vpc = true
  tags = {
    Name = "${data.aws_subnet.public_subnets[count.index].tags["Name"]}NatGatewayEip"
  }
}

# Create a NAT gateway in each of the public subnets
resource "aws_nat_gateway" "nat_gateway" {
  count = length(var.public_subnet_ids)
  subnet_id = data.aws_subnet.public_subnets[count.index].id
  # Link the NAT gateway to the elastic IP we created
  allocation_id = var.eip_allocation_ids == null ? aws_eip.nat_gateway_eip[count.index].id : var.eip_allocation_ids[count.index]
  tags = {
    Name = "${data.aws_subnet.public_subnets[count.index].tags["Name"]}NatGateway"
    AvailabilityZone = data.aws_subnet.public_subnets[count.index].tags["AvailabilityZone"]
  }
}

# Create a route in each private subnet back to the appropriate NAT gateway
resource "aws_route" "route_nat_gateway" {
  count = length(var.private_subnet_ids)

  route_table_id = data.aws_route_table.private_subnets[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = flatten([
    for nat_gateway in aws_nat_gateway.nat_gateway: flatten([
      for subnet in data.aws_subnet.public_subnets: nat_gateway["id"]
      if nat_gateway["tags"]["AvailabilityZone"] == subnet.availability_zone
    ])
  ])[0]
}
