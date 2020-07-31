# ------------------------------------------------------------------------------------------------------------------------
# Security groups
# ------------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_security_group" "security_groups" {
  for_each = var.security_groups
  # Convert name to camel case
  name = join("", [for element in split("_", replace(lower(each.key), "-", "_")): title(element)])
  # Optionally append the VPC description to the end of the description if multiple VPCs are sharing same account
  description = var.append_vpc_description == true ? "${each.value} (${data.aws_vpc.vpc.tags["Description"]})" : each.value
  vpc_id = var.vpc_id
  tags = {
    Name = join("", [for element in split("_", replace(lower(each.key), "-", "_")): title(element)])
    Description = var.append_vpc_description == true ? "${each.value} (${data.aws_vpc.vpc.tags["Description"]})" : each.value
  }
}
