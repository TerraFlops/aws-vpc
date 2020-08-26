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

variable "instance_type" {
  description = "EC2 instance type to launch. If none entered defaults to a 't3a.nano' instance"
  type = string
  default = "t3a.nano"
}

variable "private_subnet_ids" {
  description = "Set of AWS subnet IDs which should be routed to the NAT gateways"
  type = list(string)
  default = []
}
