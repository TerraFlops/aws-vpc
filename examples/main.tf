provider "aws" {
  region = "ap-southeast-2"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

module "vpc" {
  source = "git::https://github.com/TerraFlops/aws-vpc.git"

  # VPC description
  name = "example"
  description = "Example Terraflops VPC"
  tags = {
    "Module" = "terraflops/aws-vpc"
  }

  # Miscellaneous settings
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_classiclink = false
  enable_classiclink_dns_support = false
  assign_generated_ipv6_cidr_block = false

  # Create a VPC with three subnets spread across the two availability zones
  cidr_block = "10.0.0.0/18"
  subnet_cidr_blocks = {
    public = [
      "10.0.10.0/24",
      "10.0.11.0/24"
    ]
    application = [
      "10.0.20.0/24",
      "10.0.21.0/24"
    ]
    data = [
      "10.0.30.0/24",
      "10.0.31.0/24"
    ]
  }
  availability_zones = [
    "ap-southeast-2a",
    "ap-southeast-2b"
  ]

  # Enable internet gateway, and route out via the "public" subnet defined above
  internet_gateway_enabled = true
  internet_gateway_subnet_type = "public"

  # Security groups
  security_groups = {
    nat_instance = "NAT instance security group"
    application = "Application security group"
    database = "Database security group"
  }
  append_vpc_description = true

  security_group_rules = {
    application = [
      {direction="inbound", entity_type="cidr_block", entity_id="application_subnet_2a", ports="all", protocol="all"},
      {direction="inbound", entity_type="cidr_block", entity_id="application_subnet_2b", ports="all", protocol="all"},
      {direction="inbound", entity_type="security_group", entity_id="database", ports="3306", protocol="tcp"},
      {direction="outbound", entity_type="cidr_block", entity_id="vpc", ports="all", protocol="all"},
    ]
    database = [
      {direction="inbound", entity_type="cidr_block", entity_id="application_subnet_2a", ports="3306", protocol="tcp"},
      {direction="inbound", entity_type="cidr_block", entity_id="application_subnet_2b", ports="3306", protocol="tcp"},
      {direction="outbound", entity_type="cidr_block", entity_id="anywhere", ports="all", protocol="all"},
    ]
  }
}
