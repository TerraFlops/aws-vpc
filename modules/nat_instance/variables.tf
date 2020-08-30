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

variable "public_subnet_names" {
  description = "Set of public subnet names"
  type = list(string)
}

variable "public_availability_zones" {
  description = "Set of availability zones for the public subnets"
  type = list(string)
  default = []
}

variable "instance_type" {
  description = "EC2 instance type to launch. If none entered defaults to a 't3a.nano' instance"
  type = string
  default = "t3a.nano"
}

variable "private_cidr_blocks" {
  description = "Set of AWS subnet CIDR blocks which should be routed to the NAT gateways"
  type = list(string)
  default = []
}

variable "private_availability_zones" {
  description = "Set of availability zones for the private subnets"
  type = list(string)
  default = []
}

variable "private_subnet_ids" {
  description = "Set of AWS subnet IDs which should be routed to the NAT gateways"
  type = list(string)
  default = []
}

variable "private_route_table_ids" {
  description = "Set of private AWS route table IDs"
  type = list(string)
}
