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
  id = var.private_subnet_ids[count.index]
  vpc_id = var.vpc_id
}

data "aws_route_table" "private_subnets" {
  count = length(var.private_subnet_ids)
  vpc_id = var.vpc_id
  subnet_id = var.private_subnet_ids[count.index]
}

# ------------------------------------------------------------------------------------------------------------------------
# NAT gateway AMI settings
# ------------------------------------------------------------------------------------------------------------------------

data "aws_ami" "nat_gateway" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "ena-support"
    values = ["true"]
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# Security group rules
# ------------------------------------------------------------------------------------------------------------------------

# Create security group rules allowing all inbound traffic from the private subnets to the NAT gateway
resource "aws_security_group_rule" "ingress" {
  security_group_id = var.security_group_id
  type = "ingress"
  cidr_blocks = [
    for subnet in data.aws_subnet.private_subnets: subnet.cidr_block
  ]
  from_port = 0
  to_port = 0
  protocol = -1
}

# Create security group rules allowing all outbound traffic to the NAT gateway
resource "aws_security_group_rule" "egress" {
  security_group_id = var.security_group_id
  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  from_port = 0
  to_port = 0
  protocol = -1
}

# ------------------------------------------------------------------------------------------------------------------------
# Create network interface for each NAT gateway
# ------------------------------------------------------------------------------------------------------------------------

# Create elastic IPs for NAT gateways is no EIP allocation IDs were specified
resource "aws_eip" "nat_gateway" {
  count = length(var.public_subnet_ids)
  network_interface = aws_network_interface.network_interface[count.index].id
  tags = {
    Name = "${data.aws_subnet.public_subnets[count.index].tags["Name"]}NatGatewayEip"
    AvailabilityZone = data.aws_subnet.public_subnets[count.index].availability_zone
  }
  lifecycle {
    ignore_changes = [
      network_interface,
      tags
    ]
  }
}

# Create ENI for the NAT gateways and attach to the Elastic IP we just created
resource "aws_network_interface" "network_interface" {
  count = length(var.public_subnet_ids)
  security_groups = [var.security_group_id]
  subnet_id = data.aws_subnet.public_subnets[count.index].id
  source_dest_check = false
  description = "NAT gateway network interface"
  tags = {
    Name = "${data.aws_subnet.public_subnets[count.index].tags["Name"]}NatGateway"
    AvailabilityZone = data.aws_subnet.public_subnets[count.index].availability_zone
  }
  lifecycle {
    ignore_changes = [
      subnet_id,
      tags
    ]
  }
}

# Create a route in each private subnet back to the appropriate NAT 
resource "aws_route" "nat_gateway" {
  count = length(var.private_subnet_ids)
  route_table_id = data.aws_route_table.private_subnets[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  # Route to the network interface that is in the same availability zone
  network_interface_id = [
    for interface in aws_network_interface.network_interface: interface.id
    if interface["tags"]["AvailabilityZone"] == data.aws_subnet.private_subnets[count.index]
  ][0]
  lifecycle {
    ignore_changes = [
      route_table_id
    ]
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# Create an EC2 instance in each public subnet
# ------------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "nat_gateway" {
  count = length(var.public_subnet_ids)
  ami = data.aws_ami.nat_gateway.id
  instance_type = var.instance_type
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.network_interface[count.index].id
  }
  tags = {
    Name = "${data.aws_subnet.public_subnets[count.index].tags["Name"]}NatGateway"
  }
  lifecycle {
    ignore_changes = [
      network_interface,
      ami,
      tags
    ]
  }
}
