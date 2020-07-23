# ------------------------------------------------------------------------------------------------------------------------
# VPC description
# ------------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "VPC Settings: Unique identifier for the VPC (must conform to AWS naming standards)"
  type = string
  default = "example-vpc"
}

variable "description" {
  description = "VPC Settings: Free-form text description of the VPC"
  type = string
  default = "Example VPC"
}

variable "tags" {
  description = "VPC Settings: Additional tags to be added to the VPC (Note: The 'Name' & 'Description' tags are automatically generated based on values entered)"
  type = map(string)
  default = {}
}

# ------------------------------------------------------------------------------------------------------------------------
# Instance tenancy settings
# ------------------------------------------------------------------------------------------------------------------------

variable "instance_tenancy" {
  description = "VPC Settings: The allowed tenancy of instances launched into the VPC. May be any of 'default', 'dedicated', or 'host'"
  type = string
  default = "default"
}

# ------------------------------------------------------------------------------------------------------------------------
# DNS settings
# ------------------------------------------------------------------------------------------------------------------------

variable "enable_dns_hostnames" {
  description = "VPC Settings: Boolean flag to enable/disable DNS hostnames in the VPC"
  type = bool
  default = true
}

variable "enable_dns_support" {
  description = "VPC Settings: Boolean flag to enable/disable DNS support in the VPC"
  type = bool
  default = true
}

# ------------------------------------------------------------------------------------------------------------------------
# ClassicLink settings
# ------------------------------------------------------------------------------------------------------------------------

variable "enable_classiclink" {
  description = "VPC Settings: Enable linking of EC2-Classic instances to VPC"
  type = bool
  default = false
}

variable "enable_classiclink_dns_support" {
  description = "VPC Settings: Enable DNS resolution of public hostnames to private IP addresses when queries over ClassicLink"
  type = bool
  default = false
}

# ------------------------------------------------------------------------------------------------------------------------
# IPv6 settings
# ------------------------------------------------------------------------------------------------------------------------

variable "assign_generated_ipv6_cidr_block" {
  description = "VPC Settings: Assign an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC"
  type = bool
  default = false
}

# ------------------------------------------------------------------------------------------------------------------------
# Availability zone settings
# ------------------------------------------------------------------------------------------------------------------------

variable "availability_zones" {
  type = list(string)
  description = "Set of availability zones"
  default = []
}

# ------------------------------------------------------------------------------------------------------------------------
# CIDR block settings
# ------------------------------------------------------------------------------------------------------------------------

variable "cidr_block" {
  type = string
  description = "CIDR block for the VPC"
  default = "10.0.0.0/18"
}

variable "subnet_cidr_blocks" {
  type = map(list(string))
  description = "Map of subnets to be created, indexed by a subnet type identifier (e.g. 'public', 'compute', 'data') with a list value defining the CIDR blocks to be created (this list must contain the same number of CIDR blocks as there are availability zones defined)"
  default = {}
}

# ------------------------------------------------------------------------------------------------------------------------
# Internet gateway settings
# ------------------------------------------------------------------------------------------------------------------------

variable "internet_gateway_enabled" {
  description = "Boolean flag which when true creates an Internet Gateway resource attached to the VPC"
  type = bool
  default = false
}

variable "internet_gateway_subnet_type" {
  description = "Identifier of the subnet which will be routed directly to Internet Gateway"
  type = string
  default = null
}

# ------------------------------------------------------------------------------------------------------------------------
# NAT instance settings
# ------------------------------------------------------------------------------------------------------------------------

variable "nat_instance_enabled" {
  description = "Boolean flag which when true creates an EC2 NAT instance in the public subnet(s) of the VPC. This arguments conflicts with 'nat_gateway_enabled' and only one of these values should be set to true."
  type = bool
  default = false
}

variable "nat_instance_image_id" {
  description = "AMI to use when launching NAT instances. If no value is specified this will be defaulted to the latest available Amazon Linux 2 image"
  type = string
  default = null
}

variable "nat_instance_security_group" {
  description = "The security group to attach to NAT instances (if applicable)"
  type = string
  default = null
}

variable "nat_instance_eip_allocation_ids" {
  description = "Optional list of Elastic IP allocation IDs to be assigned to NAT instances"
  type = list(string)
  default = []
}

# ------------------------------------------------------------------------------------------------------------------------
# NAT gateway settings
# ------------------------------------------------------------------------------------------------------------------------

variable "nat_gateway_enabled" {
  description = "Boolean flag which when true create native AWS NAT gateways in the public subnet(s) of the VPC. This arguments conflicts with 'nat_instance_enabled' and only one of these values should be set to true."
  type = bool
  default = false
}

# ------------------------------------------------------------------------------------------------------------------------
# Security group settings
# ------------------------------------------------------------------------------------------------------------------------

variable "security_groups" {
  description = "A map of security groups that are to be created"
  type = map(string)
  default = {}
}

variable "append_vpc_description" {
  description = "Boolean flag, if True appends the VPC name at the end of all security group descriptions"
  type = bool
  default = false
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
  default = {}
}

variable "security_group_lookup_protocol_names" {
  description = "A map of port names. This is used in the automatic generation of Security Group rule descriptions and can be used to override/extend the default lookup table (optional)"
  type = map(string)
  default = {}
}

variable "security_group_lookup_cidr_blocks" {
  description = "A map of CIDR blocks. The key in the map should be used when referencing CIDR block in security group rules. This allows for easier reading of the security group rules in the terraform configuration, and also allows for more meaningful descriptions to be added to the rules when they are created"
  type = map(object({
    name = string
    cidr_block = string
  }))
  default = {}
}

variable "security_group_name_append_vpc_description" {
  description = "Boolean flag, if True appends the VPC name at the end of all security group descriptions"
  type = bool
  default = false
}