# ------------------------------------------------------------------------------------------------------------------------
# Security group rules
# ------------------------------------------------------------------------------------------------------------------------

# Create security group rules where the other entity is a CIDR block
resource "aws_security_group_rule" "cidr_block" {
  for_each = local.cidr_group_rules
  security_group_id = each.value["security_group_id"]
  type = each.value["type"]
  from_port = each.value["from_port"]
  to_port = each.value["to_port"]
  protocol = each.value["protocol"]
  cidr_blocks = each.value["cidr_blocks"]
  description = each.value["description"]
}

# Create security group rules where the other entity is a security group
resource "aws_security_group_rule" "security_group" {
  for_each = local.security_group_rules
  security_group_id = each.value["security_group_id"]
  type = each.value["type"]
  from_port = each.value["from_port"]
  to_port = each.value["to_port"]
  protocol = each.value["protocol"]
  source_security_group_id = each.value["source_security_group_id"]
  description = each.value["description"]
}
