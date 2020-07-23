# ------------------------------------------------------------------------------------------------------------------------
# Retrieve AWS resources
# ------------------------------------------------------------------------------------------------------------------------

data "aws_subnet" "public_subnets" {
  for_each = var.public_subnet_ids
  id = each.value
  vpc_id = var.vpc_id
}

data "aws_subnet" "private_subnets" {
  for_each = var.private_subnet_ids
  id = each.value
  vpc_id = var.vpc_id
}

data "aws_route_table" "private_subnets" {
  for_each = var.private_subnet_ids
  vpc_id = var.vpc_id
  subnet_id = each.value
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
    values = ["amzn2-ami-hvm-*"]
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

# Create elastic IPs for NAT instances
resource "aws_eip" "nat_instance" {
  for_each = data.aws_subnet.public_subnets
  network_interface = aws_network_interface.network_interface[each.key].id

  tags = {
    Name = "${each.value.tags["Name"]}-nat-instance-eip"
  }
}

# Create ENI for the NAT instances and attach to the Elastic IP we just created
resource "aws_network_interface" "network_interface" {
  for_each = data.aws_subnet.public_subnets

  security_groups = [var.security_group_id]
  subnet_id = each.value.id
  source_dest_check = false
  description = "NAT instance network interface"

  tags = {
    Name = "${each.value.tags["Name"]}-nat-instance"
    AvailabilityZone = each.value.availability_zone
  }
}

# Create a route in each private subnet back to the appropriate NAT instance
resource "aws_route" "nat_instance" {
  for_each = data.aws_subnet.private_subnets
  route_table_id = data.aws_route_table.private_subnets[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id = [
    for interface in aws_network_interface.network_interface: interface.id
    if interface.tags["AvailabilityZone"] == each.value.availability_zone
  ][0]
}

# Create launch template for the EC2 NAT instances
resource "aws_launch_template" "nat_instance" {
  for_each = data.aws_subnet.public_subnets

  name = "${each.value.tags["Name"]}-nat-instance-launch-template"
  description = "NAT instance launch template"
  image_id = data.aws_ami.nat_instance.id

  iam_instance_profile {
    arn = aws_iam_instance_profile.nat_instance_role.arn
  }

  # Attach network interface we created
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [ var.security_group_id ]
    delete_on_termination = true
  }

  # Create launch userdata
  user_data = base64encode(join("\n", [
    "#cloud-config",
    yamlencode({
      write_files : concat([
        {
          path : "/opt/nat/runonce.sh",
          content : templatefile("${path.module}/nat_instance/runonce.sh", {
            eni_id = aws_network_interface.network_interface[each.key].id
          }),
          permissions : "0755",
        },
        {
          path : "/opt/nat/nat.sh",
          content : file("${path.module}/nat_instance/nat.sh"),
          permissions : "0755",
        },
        {
          path : "/etc/systemd/system/nat.service",
          content : file("${path.module}/nat_instance/nat.service"),
        },
      ]),
      runcmd : [
        "/opt/nat/runonce.sh"],
    })
  ]))

  tags = {
    Name = "nat-instance-launch-template"
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# Auto-scaling group
# ------------------------------------------------------------------------------------------------------------------------

# We are going to launch each NAT instance into its own auto-scaling group, this will ensure that it is kept alive if it
# is unexpectedly terminated

resource "aws_autoscaling_group" "nat_instance" {
  for_each = data.aws_subnet.public_subnets

  # Name the ASG
  name = "${each.value.tags["Name"]}-nat-gateway-autoscaling-group"

  # We only ever want a single NAT instance in each subnet
  desired_capacity = 1
  min_size = 1
  max_size = 1

  # Launch a NAT instance in each of the subnets
  vpc_zone_identifier = [
    each.value.id
  ]

  # Tag each instance with an appropriate name
  tag {
    key = "Name"
    value = "${each.value.tags["Name"]}-nat-gateway"
    propagate_at_launch = true
  }

  mixed_instances_policy {
    # Launch NAT instances as on-demand to ensure we don't have spot instance dying on us unexpectedly
    instances_distribution {
      on_demand_base_capacity = 1
      on_demand_percentage_above_base_capacity = 100
    }

    # Link to the launch template we created
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.nat_instance[each.key].id
        version = "$Latest"
      }
      dynamic "override" {
        # Specify suitable instance types
        for_each = [
          "t3.nano",
          "t3a.nano"
        ]
        content {
          instance_type = override.value
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# IAM policy documents
# ------------------------------------------------------------------------------------------------------------------------

# Create policy document allowing EC2 service to assume the role
data "aws_iam_policy_document" "nat_instance_ec2_assume_role" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

# Create policy document allowing EC2 NAT instances to attach network interfaces
data "aws_iam_policy_document" "nat_instance_ec2_attach_network_interface" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    resources = [
      "*"
    ]
    actions = [
      "ec2:AttachNetworkInterface"
    ]
  }
}

# ------------------------------------------------------------------------------------------------------------------------
# IAM role and instance profile
# ------------------------------------------------------------------------------------------------------------------------

# Create IAM role for the NAT instances
resource "aws_iam_role" "nat_instance_role" {
  name = "NatInstance"
  assume_role_policy = data.aws_iam_policy_document.nat_instance_ec2_assume_role.json
}

# Create IAM profile for the EC2 instance
resource "aws_iam_instance_profile" "nat_instance_role" {
  name = "nat-instance-iam-profile"
  role = aws_iam_role.nat_instance_role.name
}

# Attach SSM managed instance core policy to the role
resource "aws_iam_role_policy_attachment" "nat_instance_ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role = aws_iam_role.nat_instance_role.name
}

# Attach policy allowing NAT instance to attach network interfaces
resource "aws_iam_role_policy" "nat_instance_eni_policy" {
  name_prefix = "NatInstancePolicy"
  role = aws_iam_role.nat_instance_role.name
  policy = data.aws_iam_policy_document.nat_instance_ec2_attach_network_interface.json
}
