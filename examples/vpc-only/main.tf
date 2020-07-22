provider "aws" {
  region = "ap-southeast-2"
}

module "vpc" {
  source = "git::https://github.com/TerraFlops/aws-vpc.git"

  # VPC description
  name = "example"
  description = "Example Terraflops VPC"
  tags = {
    "Module" = "terraflops/aws-vpc"
  }

  cidr_block = "10.0.0.0/18"

  # Miscellaneous settings
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_classiclink = false
  enable_classiclink_dns_support = false
  assign_generated_ipv6_cidr_block = false
}
