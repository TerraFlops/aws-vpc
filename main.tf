# ------------------------------------------------------------------------------------------------------------------------
# Create VPC
# ------------------------------------------------------------------------------------------------------------------------

locals {
  vpc_name = join("", [for element in split("_", replace(lower(var.name), "-", "_")): title(element)])
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  # Create tags for the name and description, overriding with user values where supplied
  tags = merge({
    Name = local.vpc_name
    Description = var.description
  }, var.tags)
}

# ------------------------------------------------------------------------------------------------------------------------
# Create subnets
# ------------------------------------------------------------------------------------------------------------------------

module "subnets" {
  source = "./modules/subnets"
  vpc_id = aws_vpc.vpc.id
  private_subnets = local.private_subnets
  public_subnets = local.public_subnets
}

# ------------------------------------------------------------------------------------------------------------------------
# VPC Flow Logs
# ------------------------------------------------------------------------------------------------------------------------

module "flow_logs" {
  count = var.enable_flow_logs == true ? 1 : 0
  source = "./modules/flow_logs"
  vpc_id = aws_vpc.vpc.id
  log_group_name = "${local.vpc_name}FlowLogs"
}

# ------------------------------------------------------------------------------------------------------------------------
# Internet gateway
# ------------------------------------------------------------------------------------------------------------------------

resource "aws_internet_gateway" "internet_gateway" {
  # Create internet gateway only if the 'internet_gateway_enable' flag is true
  count = var.internet_gateway_enabled == true ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${aws_vpc.vpc.tags["Name"]}InternetGateway"
    Description = "Internet gateway"
  }
}

# If an Internet Gateway ID was specified, add default route to each of the public subnets
resource "aws_route" "route_internet_gateway" {
  # Only create the route if we created the internet gateway above
  for_each = tomap({
    for id, subnet in module.subnets.public_subnets: id => subnet
    if var.internet_gateway_enabled == true
  })
  # Add the route to all of the public subnet route tables
  route_table_id = module.subnets.public_route_tables[each.key]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway[0].id
}

# ------------------------------------------------------------------------------------------------------------------------
# Create security groups and rules
# ------------------------------------------------------------------------------------------------------------------------

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = aws_vpc.vpc.id
  security_groups = var.security_groups
  append_vpc_description = var.append_vpc_description
}

module "security_group_rules" {
  depends_on = [
    module.security_groups.security_groups
  ]
  source = "./modules/security_group_rules"
  vpc_id = aws_vpc.vpc.id
  security_group_rules = var.security_group_rules
  lookup_protocol_names = var.security_group_lookup_protocol_names
  lookup_cidr_blocks = local.lookup_cidr_blocks
}

# ------------------------------------------------------------------------------------------------------------------------
# Create NAT instance
# ------------------------------------------------------------------------------------------------------------------------

module "nat_instance" {
  # Only create NAT instance if we have an Internet Gateway enabled, and the NAT gateway is disabled- otherwise this will
  # fail due to the VPC not having an attached Internet Gateway, or due to routing conflicts
  count = var.nat_instance_enabled == true && var.nat_gateway_enabled == false && var.internet_gateway_enabled == true ? 1 : 0

  depends_on = [
    module.security_groups.security_groups,
    aws_internet_gateway.internet_gateway
  ]

  source = "./modules/nat_instance"
  security_group_id = module.security_groups.security_group_ids[var.nat_instance_security_group]
  vpc_id = aws_vpc.vpc.id
  private_subnet_ids = [ for subnet in module.subnets.private_subnets: subnet["id"] ]
  public_subnet_ids = [ for subnet in module.subnets.public_subnets: subnet["id"] ]
  eip_allocation_ids = var.nat_instance_eip_allocation_ids
}

# ------------------------------------------------------------------------------------------------------------------------
# Create NAT gateway
# ------------------------------------------------------------------------------------------------------------------------

module "nat_gateway" {
  # Only create NAT gateway if we have an Internet Gateway enabled, and the NAT instnace is disabled- otherwise this will
  # fail due to the VPC not having an attached Internet Gateway, or due to routing conflicts
  count = var.nat_instance_enabled == false && var.nat_gateway_enabled == true && var.internet_gateway_enabled == true ? 1 : 0

  source = "./modules/nat_gateway"
  vpc_id = aws_vpc.vpc.id
  private_subnet_ids = [ for subnet in module.subnets.private_subnets: subnet["id"] ]
  public_subnet_ids = [ for subnet in module.subnets.public_subnets: subnet["id"] ]
  security_group_id = module.security_groups.security_group_ids[var.nat_gateway_security_group]
  eip_allocation_ids = var.nat_instance_eip_allocation_ids
}