variable "vpc_id" {
  description = "The AWS resource ID of the VPC to with which the subnets are associated"
  type = string
}

variable "security_group_id" {
  description = "The AWS security group ID to be assigned to the NAT instances"
  type = string
}

variable "public_subnet_ids" {
  description = "Set of AWS subnet IDs in which NAT instances should be created"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "Set of AWS subnet IDs which should be routed to the NAT instances"
  type = list(string)
  default = []
}
