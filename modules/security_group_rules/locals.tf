# Retrieve all of the security groups that we require to create these rules
data "aws_security_group" "security_group_rules" {
  depends_on = [
    aws_security_group_rule.security_group
  ]
  for_each = var.security_group_rules
  name = join("", [for element in split("_", replace(lower(each.key), "-", "_")): title(element)])
  vpc_id = var.vpc_id
}

locals {
  # Below are are breaking the supplied security group rules up into two variables which we will iterate over when creating the required resources

  # CIDR block rules
  cidr_group_rules = tomap({
    for security_group_rule in flatten([
      for id, rules in var.security_group_rules: flatten([
        for rule in rules: {
          # Create a unique Terraform identifier for each rule based on its contents, this is a big ugly mangling of strings to
          # form something that looks like this: "database_inbound_from_example_terraflops_vpc_ports_3306_protocol_tcp"
          id = lower(join("_", [id, rule["direction"], rule["direction"] == "inbound" ? "from": "to", replace(replace(local.lookup_cidr_blocks[lower(rule["entity_id"])]["name"], " ", "_"), "-", "_"), "ports", replace(rule["ports"], "-", "_"), "protocol", rule["protocol"]]))
          type = rule["direction"] == "inbound" ? "ingress" : "egress"
          security_group_id = data.aws_security_group.security_group_rules[id].id
          from_port = length(split("-", rule["ports"])) == 2 ? split("-", rule["ports"])[0] : rule["ports"] == "all" ? 0 : rule["ports"]
          to_port = length(split("-", rule["ports"])) == 2 ? split("-", rule["ports"])[1] : rule["ports"] == "all" ? 0 : rule["ports"]
          protocol = lower(rule["protocol"])
          cidr_blocks = [local.lookup_cidr_blocks[rule["entity_id"]]["cidr_block"]]
          description = join(" ", [
              rule["direction"] == "inbound" ? "Inbound from" : "Outbound to",
            contains(keys(local.lookup_cidr_blocks), tostring(rule["entity_id"])) ? local.lookup_cidr_blocks[rule["entity_id"]]["name"] : rule["entity_id"],
            contains(keys(local.lookup_protocol_names), tostring(rule["protocol"])) ? "(${local.lookup_protocol_names[rule["protocol"]]})" : "(${upper(rule["protocol"])})"
          ])
        }
        # Filter to CIDR block rules
        if rule["entity_type"] == "cidr_block"
      ])
    ]): security_group_rule["id"] => security_group_rule
  })

  # Security group rules
  security_group_rules = tomap({
    for security_group_rule in flatten([
      for id, rules in var.security_group_rules: flatten([
        for rule in rules: {
          # Create a unique Terraform identifier for each rule based on its contents, this is a big ugly mangling of strings to
          # form something that looks like this: "nat_instance_outbound_to_database_ports_all_protocol_all"
          id = lower(join("_", [id, rule["direction"], rule["direction"] == "inbound" ? "from": "to", replace(lower(rule["entity_id"]), "-", "_"), "ports", replace(rule["ports"], "-", "_"), "protocol", rule["protocol"]]))
          type = rule["direction"] == "inbound" ? "ingress" : "egress"
          security_group_id = data.aws_security_group.security_group_rules[id].id
          from_port = length(split("-", rule["ports"])) == 2 ? split("-", rule["ports"])[0] : rule["ports"] == "all" ? 0 : rule["ports"]
          to_port = length(split("-", rule["ports"])) == 2 ? split("-", rule["ports"])[1] : rule["ports"] == "all" ? 0 : rule["ports"]
          protocol = lower(rule["protocol"])
          source_security_group_id = data.aws_security_group.security_group_rules[id].id
          description = join(" ", [
            rule["direction"] == "inbound" ? "Inbound from" : "Outbound to",
            contains(keys(local.lookup_cidr_blocks), tostring(rule["entity_id"])) ? local.lookup_cidr_blocks[rule["entity_id"]]["name"] : rule["entity_id"],
            contains(keys(local.lookup_protocol_names), tostring(rule["protocol"])) ? "(${local.lookup_protocol_names[rule["protocol"]]})" : "(${upper(rule["protocol"])})"
          ])
        }
        # Filter to security group rules rules
        if rule["entity_type"] == "security_group"
      ])
    ]): security_group_rule["id"] => security_group_rule
  })
}
