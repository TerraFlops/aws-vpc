# ------------------------------------------------------------------------------------------------------------------------
# Create VPC
# ------------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  # Create tags for the name and description, overriding with user values where supplied
  tags = merge({
    Name = join("", [for element in split("_", replace(lower(var.name), "-", "_")): title(element)])
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
