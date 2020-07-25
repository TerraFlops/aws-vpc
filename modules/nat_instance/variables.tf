variable "vpc_id" {
  description = "The AWS resource ID of the VPC to with which the subnets are associated"
  type = string
}

variable "security_group_id" {
  description = "The AWS security group ID to be assigned to the NAT gateways"
  type = string
}

variable "public_subnet_ids" {
  description = "Set of AWS subnet IDs in which NAT gateways should be created"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "Set of AWS subnet IDs which should be routed to the NAT gateways"
  type = list(string)
  default = []
}

variable "eip_allocation_ids" {
  description = "Optional list of Elastic IP allocation IDs to be assigned to NAT gateways, if supplied you must have the same number of EIPs as public subnets or it will be ignored"
  type = list(string)
  default = []
}
