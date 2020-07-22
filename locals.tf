locals {
  # ------------------------------------------------------------------------------------------------------------------------
  # Public subnets
  # ------------------------------------------------------------------------------------------------------------------------

  # Start by creating a flat array of all unique public subnet types and their CIDR blocks
  public_subnets_array = flatten([
    for subnet_type, cidr_blocks in var.subnet_cidr_blocks: [
      for cidr_block in cidr_blocks: {
        subnet_type = subnet_type
        availability_zone = var.availability_zones[index(cidr_blocks, cidr_block)]
        availability_zone_suffix = element(split("-", lower(var.availability_zones[index(cidr_blocks, cidr_block)])), length(split("-", lower(var.availability_zones[index(cidr_blocks, cidr_block)])))-1)
        cidr_block = cidr_block
      }
    ]
    # Filter to public subnet type only
    if var.internet_gateway_subnet_type == subnet_type
  ])

  # From this array create a map of public subnets indexed by a unique subnet ID (e.g. "public-subnet-2a", "public-subnet-2b", "compute-subnet-2a", "compute-subnet-2b")
  public_subnets = tomap({
    for subnet in local.public_subnets_array: lower("${subnet["subnet_type"]}_subnet_${subnet["availability_zone_suffix"]}") => {
      subnet_type = subnet["subnet_type"]
      cidr_block = subnet["cidr_block"]
      availability_zone = subnet["availability_zone"]
      availability_zone_suffix = subnet["availability_zone_suffix"]
    }
  })

  # ------------------------------------------------------------------------------------------------------------------------
  # Private subnets
  # ------------------------------------------------------------------------------------------------------------------------

  # Start by creating a flat array of all unique private subnet types and their CIDR blocks
  private_subnets_array = flatten([
    for subnet_type, cidr_blocks in var.subnet_cidr_blocks: [
      for cidr_block in cidr_blocks: {
        subnet_type = subnet_type
        availability_zone = var.availability_zones[index(cidr_blocks, cidr_block)]
        availability_zone_suffix = element(split("-", lower(var.availability_zones[index(cidr_blocks, cidr_block)])), length(split("-", lower(var.availability_zones[index(cidr_blocks, cidr_block)])))-1)
        cidr_block = cidr_block
      }
    ]
    # Filter to private subnet type only
    if var.internet_gateway_subnet_type != subnet_type
  ])

  # From this array create a map of private subnets indexed by a unique subnet ID (e.g. "private-subnet-2a", "private-subnet-2b", "compute-subnet-2a", "compute-subnet-2b")
  private_subnets = tomap({
    for subnet in local.private_subnets_array: "${subnet["subnet_type"]}_subnet_${subnet["availability_zone_suffix"]}" => {
      subnet_type = subnet["subnet_type"]
      cidr_block = subnet["cidr_block"]
      availability_zone = subnet["availability_zone"]
      availability_zone_suffix = subnet["availability_zone_suffix"]
    }
  })

  # ------------------------------------------------------------------------------------------------------------------------
  # Lookup for security group rules
  # ------------------------------------------------------------------------------------------------------------------------

  lookup_cidr_blocks = merge(
    # Automatically append a lookup with the VPC CIDR block
    {
      "vpc" = {
        name = var.description
        cidr_block = var.cidr_block
      }
    },
    # Automatically append all of the subnet CIDR block as lookups (e.g. "public_subnet_2a", "compute_subnet_2b")
    tomap({
      for subnet_id, subnet in local.public_subnets:
      subnet_id => {
        name = "${title(subnet["subnet_type"])} Subnet ${upper(subnet["availability_zone_suffix"])}"
        cidr_block = subnet["cidr_block"]
      }
    }),
    tomap({
      for subnet_id, subnet in local.private_subnets:
      subnet_id => {
        name = "${title(subnet["subnet_type"])} Subnet ${upper(subnet["availability_zone_suffix"])}"
        cidr_block = subnet["cidr_block"]
      }
    }),
    # Override this with any lookup values that were passed into the function
    var.security_group_lookup_cidr_blocks
  )

  # ------------------------------------------------------------------------------------------------------------------------
  # Output helpers
  # ------------------------------------------------------------------------------------------------------------------------

  # Combine the public/private subnets for output
  output_subnets = merge(module.subnets.public_subnets, module.subnets.private_subnets)

  # Combine the public/private route tables for output
  output_route_tables = merge(module.subnets.public_route_tables, module.subnets.private_route_tables)
}