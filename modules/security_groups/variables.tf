variable "vpc_id" {
  description = "The AWS resource ID of the VPC to with which the subnets are associated"
  type = string
}

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
