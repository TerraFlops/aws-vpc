variable "vpc_id" {
  description = "The AWS resource ID of the VPC to with which the subnets are associated"
  type = string
}

variable "private_subnets" {
  description = "Map of private subnets indexed by their identifier"
  type = map(object({
    subnet_type = string
    cidr_block = string
    availability_zone = string
  }))
  default = {}
}

variable "public_subnets" {
  description = "Map of public subnets indexed by their identifier"
  type = map(object({
    subnet_type = string
    cidr_block = string
    availability_zone = string
  }))
  default = {}
}