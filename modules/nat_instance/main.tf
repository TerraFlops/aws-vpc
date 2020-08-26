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
# NAT instance AMI settings
# ------------------------------------------------------------------------------------------------------------------------

data "aws_ami" "nat_instance" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "name"
    values = ["amzn-ami-vpc-nat-2018.03*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# Security group rules
# ------------------------------------------------------------------------------------------------------------------------

# Create security group rules allowing all inbound traffic from the private subnets to the NAT instance
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

# Create security group rules allowing all outbound traffic to the NAT instance
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

# Create elastic IPs for NAT instances is no EIP allocation IDs were specified
resource "aws_eip" "nat_instance" {
  count = length(var.public_subnet_ids)
  network_interface = aws_network_interface.network_interface[count.index].id

  tags = {
    Name = "${data.aws_subnet.public_subnets[count.index].tags["Name"]}NatInstanceEip"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Create ENI for the NAT instances and attach to the Elastic IP we just created
resource "aws_network_interface" "network_interface" {
  count = length(var.public_subnet_ids)

  security_groups = [var.security_group_id]
  subnet_id = data.aws_subnet.public_subnets[count.index].id
  source_dest_check = false
  description = "NAT instance network interface"

  tags = {
    Name = "${data.aws_subnet.public_subnets[count.index].tags["Name"]}NatGateway"
    AvailabilityZone = data.aws_subnet.public_subnets[count.index].availability_zone
  }
}

# Create a route in each private subnet back to the appropriate NAT instance
resource "aws_route" "nat_instance" {
  count = length(var.private_subnet_ids)

  route_table_id = data.aws_route_table.private_subnets[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id = flatten([
    for interface in aws_network_interface.network_interface: flatten([
      for subnet in data.aws_subnet.public_subnets: interface["id"]
      if interface["tags"]["AvailabilityZone"] == subnet.availability_zone
    ])
  ])[0]

  lifecycle {
    ignore_changes = [
      route_table_id
    ]
  }
}

# Create a NAT instance in each public subnet
resource "aws_instance" "nat_instance" {
  count = length(var.public_subnet_ids)
  ami = data.aws_ami.nat_instance.id
  instance_type = "t3a.nano"
  network_interface {
    device_index = 0
    network_interface_id = flatten([
      for interface in aws_network_interface.network_interface: flatten([
        for subnet in data.aws_subnet.public_subnets: interface["id"]
        if interface["tags"]["AvailabilityZone"] == subnet.availability_zone
      ])
    ])[0]
    security_groups = [
    var.security_group_id
  ]
    subnet_id = data.aws_subnet.public_subnets[count.index].id
  }

  tags = {
    Name = "${data.aws_subnet.public_subnets[count.index].tags["Name"]}NatGateway"
  }
}
