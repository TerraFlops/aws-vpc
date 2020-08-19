variable "vpc_id" {
  description = "The AWS resource ID of the VPC to with which the subnets are associated"
  type = string
}

variable "security_group_ids" {
  description = "Map of security group IDs"
  type = map(string)
  default = {}
}

variable "security_group_rules" {
  description = "List of security group ingress rules to be created"
  type = map(list(object({
    direction = string      # Direction of rule, must be one of 'inbound' or 'outbound'
    entity_type = string    # Must be one of 'cidr_block' or 'security_group'
    entity_id = string      # Either the Terraform identifier of the security group, or the CIDR block (depending on the 'entity_type' value nominated above)
    ports = string          # Must be either a port range (e.g. '0-65535') or a single port number (e.g. '3306')
    protocol = string       # Must be either of 'tcp', 'udp', 'icmp' or 'all'
  })))
}

variable "lookup_protocol_names" {
  description = "A map of port names. This is used in the automatic generation of Security Group rule descriptions and can be used to override/extend the default lookup table (optional)"
  type = map(string)
  default = {}
}

variable "lookup_cidr_blocks" {
  description = "A map of CIDR blocks. The key in the map should be used when referencing CIDR block in security group rules. This allows for easier reading of the security group rules in the terraform configuration, and also allows for more meaningful descriptions to be added to the rules when they are created"
  type = map(object({
    name = string
    cidr_block = string
  }))
  default = {}
}