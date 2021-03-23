# ------------------------------------------------------------------------------------------------------------------------
# Public subnets
# ------------------------------------------------------------------------------------------------------------------------

# Create each subnet
resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets
  vpc_id = var.vpc_id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = join("", [for element in split("_", replace(lower(each.key), "-", "_")): title(element)])
    SubnetType = join("", [for element in split("_", replace(lower(each.value.subnet_type), "-", "_")): title(element)])
    Public = "True"
  }
}

# Create route table for each of the public subnets
resource "aws_route_table" "public_subnets" {
  for_each = var.public_subnets
  vpc_id = var.vpc_id
  tags = {
    Name = join("", [for element in split("_", replace(lower(each.key), "-", "_")): title(element)])
    SubnetType = join("", [for element in split("_", replace(lower(each.value.subnet_type), "-", "_")): title(element)])
  }
}

# Link each route table to its subnet
resource "aws_route_table_association" "public_subnets" {
  for_each = var.public_subnets
  route_table_id = aws_route_table.public_subnets[each.key].id
  subnet_id = aws_subnet.public_subnets[each.key].id
}

# ------------------------------------------------------------------------------------------------------------------------
# Private subnets
# ------------------------------------------------------------------------------------------------------------------------

# Create each subnet
resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets
  vpc_id = var.vpc_id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = join("", [for element in split("_", replace(lower(each.key), "-", "_")): title(element)])
    SubnetType = join("", [for element in split("_", replace(lower(each.value.subnet_type), "-", "_")): title(element)])
    Public = "False"
  }
}
# Create route table for each of the private subnets
resource "aws_route_table" "private_subnets" {
  for_each = var.private_subnets
  vpc_id = var.vpc_id
  tags = {
    Name = join("", [for element in split("_", replace(lower(each.key), "-", "_")): title(element)])
    SubnetType = join("", [for element in split("_", replace(lower(each.value.subnet_type), "-", "_")): title(element)])
  }
}

# Link each route table to its subnet
resource "aws_route_table_association" "private_subnets" {
  for_each = var.private_subnets
  route_table_id = aws_route_table.private_subnets[each.key].id
  subnet_id = aws_subnet.private_subnets[each.key].id
}
