# Example VPC with Multiple Subnets

## Example Usage

```hcl-terraform
$ tf init

    Initializing modules...
    Downloading git::https://github.com/TerraFlops/aws-vpc.git for vpc...
    - vpc in .terraform/modules/vpc
    - vpc.security_group_rules in .terraform/modules/vpc/modules/security_group_rules
    - vpc.security_groups in .terraform/modules/vpc/modules/security_groups
    - vpc.subnets in .terraform/modules/vpc/modules/subnets
    
    Initializing the backend...
    
    Initializing provider plugins...
    - Using previously-installed hashicorp/aws v2.70.0
    
    The following providers do not have any version constraints in configuration,
    so the latest version was installed.
    
    To prevent automatic upgrades to new major versions that may contain breaking
    changes, we recommend adding version constraints in a required_providers block
    in your configuration, with the constraint strings suggested below.
    
    * hashicorp/aws: version = "~> 2.70.0"
    
    Terraform has been successfully initialized!
    
    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.
    
    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.

$ tf plan

    Refreshing Terraform state in-memory prior to plan...
    The refreshed state will be used to calculate this plan, but will not be
    persisted to local or remote state storage.
    
    
    ------------------------------------------------------------------------
    
    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
      + create
     <= read (data resources)
    
    Terraform will perform the following actions:
    
      # module.vpc.aws_internet_gateway.internet_gateway[0] will be created
      + resource "aws_internet_gateway" "internet_gateway" {
          + arn      = (known after apply)
          + id       = (known after apply)
          + owner_id = (known after apply)
          + tags     = {
              + "Description" = "Internet gateway"
              + "Name"        = "ExampleInternetGateway"
            }
          + vpc_id   = (known after apply)
        }
    
      # module.vpc.aws_route.route_internet_gateway["public_subnet_2a"] will be created
      + resource "aws_route" "route_internet_gateway" {
          + destination_cidr_block     = "0.0.0.0/0"
          + destination_prefix_list_id = (known after apply)
          + egress_only_gateway_id     = (known after apply)
          + gateway_id                 = (known after apply)
          + id                         = (known after apply)
          + instance_id                = (known after apply)
          + instance_owner_id          = (known after apply)
          + nat_gateway_id             = (known after apply)
          + network_interface_id       = (known after apply)
          + origin                     = (known after apply)
          + route_table_id             = (known after apply)
          + state                      = (known after apply)
        }
    
      # module.vpc.aws_route.route_internet_gateway["public_subnet_2b"] will be created
      + resource "aws_route" "route_internet_gateway" {
          + destination_cidr_block     = "0.0.0.0/0"
          + destination_prefix_list_id = (known after apply)
          + egress_only_gateway_id     = (known after apply)
          + gateway_id                 = (known after apply)
          + id                         = (known after apply)
          + instance_id                = (known after apply)
          + instance_owner_id          = (known after apply)
          + nat_gateway_id             = (known after apply)
          + network_interface_id       = (known after apply)
          + origin                     = (known after apply)
          + route_table_id             = (known after apply)
          + state                      = (known after apply)
        }
    
      # module.vpc.aws_vpc.vpc will be created
      + resource "aws_vpc" "vpc" {
          + arn                              = (known after apply)
          + assign_generated_ipv6_cidr_block = false
          + cidr_block                       = "10.0.0.0/18"
          + default_network_acl_id           = (known after apply)
          + default_route_table_id           = (known after apply)
          + default_security_group_id        = (known after apply)
          + dhcp_options_id                  = (known after apply)
          + enable_classiclink               = (known after apply)
          + enable_classiclink_dns_support   = (known after apply)
          + enable_dns_hostnames             = true
          + enable_dns_support               = true
          + id                               = (known after apply)
          + instance_tenancy                 = "default"
          + ipv6_association_id              = (known after apply)
          + ipv6_cidr_block                  = (known after apply)
          + main_route_table_id              = (known after apply)
          + owner_id                         = (known after apply)
          + tags                             = {
              + "Description" = "Example Terraflops VPC"
              + "Module"      = "terraflops/aws-vpc"
              + "Name"        = "Example"
            }
        }
    
      # module.vpc.module.security_group_rules.data.aws_security_group.security_group_rules["application"] will be read during apply
      # (config refers to values not yet known)
     <= data "aws_security_group" "security_group_rules"  {
          + arn         = (known after apply)
          + description = (known after apply)
          + id          = (known after apply)
          + name        = "Application"
          + tags        = (known after apply)
          + vpc_id      = (known after apply)
        }
    
      # module.vpc.module.security_group_rules.data.aws_security_group.security_group_rules["database"] will be read during apply
      # (config refers to values not yet known)
     <= data "aws_security_group" "security_group_rules"  {
          + arn         = (known after apply)
          + description = (known after apply)
          + id          = (known after apply)
          + name        = "Database"
          + tags        = (known after apply)
          + vpc_id      = (known after apply)
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_inbound_from_anywhere_ports_all_protocol_all"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "0.0.0.0/0",
            ]
          + description              = "Inbound from Anywhere (ALL)"
          + from_port                = 0
          + id                       = (known after apply)
          + protocol                 = "-1"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 0
          + type                     = "ingress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_outbound_to_anywhere_ports_all_protocol_all"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "0.0.0.0/0",
            ]
          + description              = "Outbound to Anywhere (ALL)"
          + from_port                = 0
          + id                       = (known after apply)
          + protocol                 = "-1"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 0
          + type                     = "egress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_outbound_to_public_subnet_2a_ports_all_protocol_all"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "10.0.10.0/24",
            ]
          + description              = "Outbound to Public Subnet 2A (ALL)"
          + from_port                = 0
          + id                       = (known after apply)
          + protocol                 = "-1"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 0
          + type                     = "egress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["database_inbound_from_example_terraflops_vpc_ports_3306_protocol_tcp"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "10.0.0.0/18",
            ]
          + description              = "Inbound from Example Terraflops VPC (TCP)"
          + from_port                = 3306
          + id                       = (known after apply)
          + protocol                 = "tcp"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 3306
          + type                     = "ingress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["database_outbound_to_anywhere_ports_all_protocol_all"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "0.0.0.0/0",
            ]
          + description              = "Outbound to Anywhere (ALL)"
          + from_port                = 0
          + id                       = (known after apply)
          + protocol                 = "-1"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 0
          + type                     = "egress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.security_group["application_inbound_from_database_ports_3306_protocol_tcp"] will be created
      + resource "aws_security_group_rule" "security_group" {
          + description              = "Inbound from database (TCP)"
          + from_port                = 3306
          + id                       = (known after apply)
          + protocol                 = "tcp"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 3306
          + type                     = "ingress"
        }
    
      # module.vpc.module.security_groups.data.aws_vpc.vpc will be read during apply
      # (config refers to values not yet known)
     <= data "aws_vpc" "vpc"  {
          + arn                     = (known after apply)
          + cidr_block              = (known after apply)
          + cidr_block_associations = (known after apply)
          + default                 = (known after apply)
          + dhcp_options_id         = (known after apply)
          + enable_dns_hostnames    = (known after apply)
          + enable_dns_support      = (known after apply)
          + id                      = (known after apply)
          + instance_tenancy        = (known after apply)
          + ipv6_association_id     = (known after apply)
          + ipv6_cidr_block         = (known after apply)
          + main_route_table_id     = (known after apply)
          + owner_id                = (known after apply)
          + state                   = (known after apply)
          + tags                    = (known after apply)
        }
    
      # module.vpc.module.security_groups.aws_security_group.security_groups["application"] will be created
      + resource "aws_security_group" "security_groups" {
          + arn                    = (known after apply)
          + description            = (known after apply)
          + egress                 = (known after apply)
          + id                     = (known after apply)
          + ingress                = (known after apply)
          + name                   = "Application"
          + owner_id               = (known after apply)
          + revoke_rules_on_delete = false
          + tags                   = (known after apply)
          + vpc_id                 = (known after apply)
        }
    
      # module.vpc.module.security_groups.aws_security_group.security_groups["database"] will be created
      + resource "aws_security_group" "security_groups" {
          + arn                    = (known after apply)
          + description            = (known after apply)
          + egress                 = (known after apply)
          + id                     = (known after apply)
          + ingress                = (known after apply)
          + name                   = "Database"
          + owner_id               = (known after apply)
          + revoke_rules_on_delete = false
          + tags                   = (known after apply)
          + vpc_id                 = (known after apply)
        }
    
      # module.vpc.module.security_groups.aws_security_group.security_groups["nat_instance"] will be created
      + resource "aws_security_group" "security_groups" {
          + arn                    = (known after apply)
          + description            = (known after apply)
          + egress                 = (known after apply)
          + id                     = (known after apply)
          + ingress                = (known after apply)
          + name                   = "NatInstance"
          + owner_id               = (known after apply)
          + revoke_rules_on_delete = false
          + tags                   = (known after apply)
          + vpc_id                 = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.private_subnets["compute_subnet_2a"] will be created
      + resource "aws_route_table" "private_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "ComputeSubnet2a"
              + "SubnetType" = "Compute"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.private_subnets["compute_subnet_2b"] will be created
      + resource "aws_route_table" "private_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "ComputeSubnet2b"
              + "SubnetType" = "Compute"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.private_subnets["data_subnet_2a"] will be created
      + resource "aws_route_table" "private_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "DataSubnet2a"
              + "SubnetType" = "Data"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.private_subnets["data_subnet_2b"] will be created
      + resource "aws_route_table" "private_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "DataSubnet2b"
              + "SubnetType" = "Data"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.public_subnets["public_subnet_2a"] will be created
      + resource "aws_route_table" "public_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "PublicSubnet2a"
              + "SubnetType" = "Public"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.public_subnets["public_subnet_2b"] will be created
      + resource "aws_route_table" "public_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "PublicSubnet2b"
              + "SubnetType" = "Public"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.private_subnets["compute_subnet_2a"] will be created
      + resource "aws_route_table_association" "private_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.private_subnets["compute_subnet_2b"] will be created
      + resource "aws_route_table_association" "private_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.private_subnets["data_subnet_2a"] will be created
      + resource "aws_route_table_association" "private_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.private_subnets["data_subnet_2b"] will be created
      + resource "aws_route_table_association" "private_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.public_subnets["public_subnet_2a"] will be created
      + resource "aws_route_table_association" "public_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.public_subnets["public_subnet_2b"] will be created
      + resource "aws_route_table_association" "public_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.private_subnets["compute_subnet_2a"] will be created
      + resource "aws_subnet" "private_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2a"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.20.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "ComputeSubnet2a"
              + "Public"     = "False"
              + "SubnetType" = "Compute"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.private_subnets["compute_subnet_2b"] will be created
      + resource "aws_subnet" "private_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2b"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.21.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "ComputeSubnet2b"
              + "Public"     = "False"
              + "SubnetType" = "Compute"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.private_subnets["data_subnet_2a"] will be created
      + resource "aws_subnet" "private_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2a"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.30.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "DataSubnet2a"
              + "Public"     = "False"
              + "SubnetType" = "Data"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.private_subnets["data_subnet_2b"] will be created
      + resource "aws_subnet" "private_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2b"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.31.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "DataSubnet2b"
              + "Public"     = "False"
              + "SubnetType" = "Data"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.public_subnets["public_subnet_2a"] will be created
      + resource "aws_subnet" "public_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2a"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.10.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "PublicSubnet2a"
              + "Public"     = "True"
              + "SubnetType" = "Public"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.public_subnets["public_subnet_2b"] will be created
      + resource "aws_subnet" "public_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2b"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.11.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "PublicSubnet2b"
              + "Public"     = "True"
              + "SubnetType" = "Public"
            }
          + vpc_id                          = (known after apply)
        }
    
    Plan: 31 to add, 0 to change, 0 to destroy.
    
    ------------------------------------------------------------------------
    
    Note: You didn't specify an "-out" parameter to save this plan, so Terraform
    can't guarantee that exactly these actions will be performed if
    "terraform apply" is subsequently run.


$ tf apply

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
      + create
     <= read (data resources)
    
    Terraform will perform the following actions:
    
      # module.vpc.aws_internet_gateway.internet_gateway[0] will be created
      + resource "aws_internet_gateway" "internet_gateway" {
          + arn      = (known after apply)
          + id       = (known after apply)
          + owner_id = (known after apply)
          + tags     = {
              + "Description" = "Internet gateway"
              + "Name"        = "ExampleInternetGateway"
            }
          + vpc_id   = (known after apply)
        }
    
      # module.vpc.aws_route.route_internet_gateway["public_subnet_2a"] will be created
      + resource "aws_route" "route_internet_gateway" {
          + destination_cidr_block     = "0.0.0.0/0"
          + destination_prefix_list_id = (known after apply)
          + egress_only_gateway_id     = (known after apply)
          + gateway_id                 = (known after apply)
          + id                         = (known after apply)
          + instance_id                = (known after apply)
          + instance_owner_id          = (known after apply)
          + nat_gateway_id             = (known after apply)
          + network_interface_id       = (known after apply)
          + origin                     = (known after apply)
          + route_table_id             = (known after apply)
          + state                      = (known after apply)
        }
    
      # module.vpc.aws_route.route_internet_gateway["public_subnet_2b"] will be created
      + resource "aws_route" "route_internet_gateway" {
          + destination_cidr_block     = "0.0.0.0/0"
          + destination_prefix_list_id = (known after apply)
          + egress_only_gateway_id     = (known after apply)
          + gateway_id                 = (known after apply)
          + id                         = (known after apply)
          + instance_id                = (known after apply)
          + instance_owner_id          = (known after apply)
          + nat_gateway_id             = (known after apply)
          + network_interface_id       = (known after apply)
          + origin                     = (known after apply)
          + route_table_id             = (known after apply)
          + state                      = (known after apply)
        }
    
      # module.vpc.aws_vpc.vpc will be created
      + resource "aws_vpc" "vpc" {
          + arn                              = (known after apply)
          + assign_generated_ipv6_cidr_block = false
          + cidr_block                       = "10.0.0.0/18"
          + default_network_acl_id           = (known after apply)
          + default_route_table_id           = (known after apply)
          + default_security_group_id        = (known after apply)
          + dhcp_options_id                  = (known after apply)
          + enable_classiclink               = (known after apply)
          + enable_classiclink_dns_support   = (known after apply)
          + enable_dns_hostnames             = true
          + enable_dns_support               = true
          + id                               = (known after apply)
          + instance_tenancy                 = "default"
          + ipv6_association_id              = (known after apply)
          + ipv6_cidr_block                  = (known after apply)
          + main_route_table_id              = (known after apply)
          + owner_id                         = (known after apply)
          + tags                             = {
              + "Description" = "Example Terraflops VPC"
              + "Module"      = "terraflops/aws-vpc"
              + "Name"        = "Example"
            }
        }
    
      # module.vpc.module.security_group_rules.data.aws_security_group.security_group_rules["application"] will be read during apply
      # (config refers to values not yet known)
     <= data "aws_security_group" "security_group_rules"  {
          + arn         = (known after apply)
          + description = (known after apply)
          + id          = (known after apply)
          + name        = "Application"
          + tags        = (known after apply)
          + vpc_id      = (known after apply)
        }
    
      # module.vpc.module.security_group_rules.data.aws_security_group.security_group_rules["database"] will be read during apply
      # (config refers to values not yet known)
     <= data "aws_security_group" "security_group_rules"  {
          + arn         = (known after apply)
          + description = (known after apply)
          + id          = (known after apply)
          + name        = "Database"
          + tags        = (known after apply)
          + vpc_id      = (known after apply)
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_inbound_from_anywhere_ports_all_protocol_all"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "0.0.0.0/0",
            ]
          + description              = "Inbound from Anywhere (ALL)"
          + from_port                = 0
          + id                       = (known after apply)
          + protocol                 = "-1"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 0
          + type                     = "ingress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_outbound_to_anywhere_ports_all_protocol_all"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "0.0.0.0/0",
            ]
          + description              = "Outbound to Anywhere (ALL)"
          + from_port                = 0
          + id                       = (known after apply)
          + protocol                 = "-1"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 0
          + type                     = "egress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_outbound_to_public_subnet_2a_ports_all_protocol_all"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "10.0.10.0/24",
            ]
          + description              = "Outbound to Public Subnet 2A (ALL)"
          + from_port                = 0
          + id                       = (known after apply)
          + protocol                 = "-1"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 0
          + type                     = "egress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["database_inbound_from_example_terraflops_vpc_ports_3306_protocol_tcp"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "10.0.0.0/18",
            ]
          + description              = "Inbound from Example Terraflops VPC (TCP)"
          + from_port                = 3306
          + id                       = (known after apply)
          + protocol                 = "tcp"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 3306
          + type                     = "ingress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["database_outbound_to_anywhere_ports_all_protocol_all"] will be created
      + resource "aws_security_group_rule" "cidr_block" {
          + cidr_blocks              = [
              + "0.0.0.0/0",
            ]
          + description              = "Outbound to Anywhere (ALL)"
          + from_port                = 0
          + id                       = (known after apply)
          + protocol                 = "-1"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 0
          + type                     = "egress"
        }
    
      # module.vpc.module.security_group_rules.aws_security_group_rule.security_group["application_inbound_from_database_ports_3306_protocol_tcp"] will be created
      + resource "aws_security_group_rule" "security_group" {
          + description              = "Inbound from database (TCP)"
          + from_port                = 3306
          + id                       = (known after apply)
          + protocol                 = "tcp"
          + security_group_id        = (known after apply)
          + self                     = false
          + source_security_group_id = (known after apply)
          + to_port                  = 3306
          + type                     = "ingress"
        }
    
      # module.vpc.module.security_groups.data.aws_vpc.vpc will be read during apply
      # (config refers to values not yet known)
     <= data "aws_vpc" "vpc"  {
          + arn                     = (known after apply)
          + cidr_block              = (known after apply)
          + cidr_block_associations = (known after apply)
          + default                 = (known after apply)
          + dhcp_options_id         = (known after apply)
          + enable_dns_hostnames    = (known after apply)
          + enable_dns_support      = (known after apply)
          + id                      = (known after apply)
          + instance_tenancy        = (known after apply)
          + ipv6_association_id     = (known after apply)
          + ipv6_cidr_block         = (known after apply)
          + main_route_table_id     = (known after apply)
          + owner_id                = (known after apply)
          + state                   = (known after apply)
          + tags                    = (known after apply)
        }
    
      # module.vpc.module.security_groups.aws_security_group.security_groups["application"] will be created
      + resource "aws_security_group" "security_groups" {
          + arn                    = (known after apply)
          + description            = (known after apply)
          + egress                 = (known after apply)
          + id                     = (known after apply)
          + ingress                = (known after apply)
          + name                   = "Application"
          + owner_id               = (known after apply)
          + revoke_rules_on_delete = false
          + tags                   = (known after apply)
          + vpc_id                 = (known after apply)
        }
    
      # module.vpc.module.security_groups.aws_security_group.security_groups["database"] will be created
      + resource "aws_security_group" "security_groups" {
          + arn                    = (known after apply)
          + description            = (known after apply)
          + egress                 = (known after apply)
          + id                     = (known after apply)
          + ingress                = (known after apply)
          + name                   = "Database"
          + owner_id               = (known after apply)
          + revoke_rules_on_delete = false
          + tags                   = (known after apply)
          + vpc_id                 = (known after apply)
        }
    
      # module.vpc.module.security_groups.aws_security_group.security_groups["nat_instance"] will be created
      + resource "aws_security_group" "security_groups" {
          + arn                    = (known after apply)
          + description            = (known after apply)
          + egress                 = (known after apply)
          + id                     = (known after apply)
          + ingress                = (known after apply)
          + name                   = "NatInstance"
          + owner_id               = (known after apply)
          + revoke_rules_on_delete = false
          + tags                   = (known after apply)
          + vpc_id                 = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.private_subnets["compute_subnet_2a"] will be created
      + resource "aws_route_table" "private_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "ComputeSubnet2a"
              + "SubnetType" = "Compute"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.private_subnets["compute_subnet_2b"] will be created
      + resource "aws_route_table" "private_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "ComputeSubnet2b"
              + "SubnetType" = "Compute"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.private_subnets["data_subnet_2a"] will be created
      + resource "aws_route_table" "private_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "DataSubnet2a"
              + "SubnetType" = "Data"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.private_subnets["data_subnet_2b"] will be created
      + resource "aws_route_table" "private_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "DataSubnet2b"
              + "SubnetType" = "Data"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.public_subnets["public_subnet_2a"] will be created
      + resource "aws_route_table" "public_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "PublicSubnet2a"
              + "SubnetType" = "Public"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table.public_subnets["public_subnet_2b"] will be created
      + resource "aws_route_table" "public_subnets" {
          + id               = (known after apply)
          + owner_id         = (known after apply)
          + propagating_vgws = (known after apply)
          + route            = (known after apply)
          + tags             = {
              + "Name"       = "PublicSubnet2b"
              + "SubnetType" = "Public"
            }
          + vpc_id           = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.private_subnets["compute_subnet_2a"] will be created
      + resource "aws_route_table_association" "private_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.private_subnets["compute_subnet_2b"] will be created
      + resource "aws_route_table_association" "private_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.private_subnets["data_subnet_2a"] will be created
      + resource "aws_route_table_association" "private_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.private_subnets["data_subnet_2b"] will be created
      + resource "aws_route_table_association" "private_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.public_subnets["public_subnet_2a"] will be created
      + resource "aws_route_table_association" "public_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_route_table_association.public_subnets["public_subnet_2b"] will be created
      + resource "aws_route_table_association" "public_subnets" {
          + id             = (known after apply)
          + route_table_id = (known after apply)
          + subnet_id      = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.private_subnets["compute_subnet_2a"] will be created
      + resource "aws_subnet" "private_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2a"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.20.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "ComputeSubnet2a"
              + "Public"     = "False"
              + "SubnetType" = "Compute"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.private_subnets["compute_subnet_2b"] will be created
      + resource "aws_subnet" "private_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2b"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.21.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "ComputeSubnet2b"
              + "Public"     = "False"
              + "SubnetType" = "Compute"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.private_subnets["data_subnet_2a"] will be created
      + resource "aws_subnet" "private_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2a"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.30.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "DataSubnet2a"
              + "Public"     = "False"
              + "SubnetType" = "Data"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.private_subnets["data_subnet_2b"] will be created
      + resource "aws_subnet" "private_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2b"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.31.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "DataSubnet2b"
              + "Public"     = "False"
              + "SubnetType" = "Data"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.public_subnets["public_subnet_2a"] will be created
      + resource "aws_subnet" "public_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2a"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.10.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "PublicSubnet2a"
              + "Public"     = "True"
              + "SubnetType" = "Public"
            }
          + vpc_id                          = (known after apply)
        }
    
      # module.vpc.module.subnets.aws_subnet.public_subnets["public_subnet_2b"] will be created
      + resource "aws_subnet" "public_subnets" {
          + arn                             = (known after apply)
          + assign_ipv6_address_on_creation = false
          + availability_zone               = "ap-southeast-2b"
          + availability_zone_id            = (known after apply)
          + cidr_block                      = "10.0.11.0/24"
          + id                              = (known after apply)
          + ipv6_cidr_block                 = (known after apply)
          + ipv6_cidr_block_association_id  = (known after apply)
          + map_public_ip_on_launch         = false
          + owner_id                        = (known after apply)
          + tags                            = {
              + "Name"       = "PublicSubnet2b"
              + "Public"     = "True"
              + "SubnetType" = "Public"
            }
          + vpc_id                          = (known after apply)
        }
    
    Plan: 31 to add, 0 to change, 0 to destroy.
    
    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.
    
      Enter a value: yes
    
    module.vpc.aws_vpc.vpc: Creating...
    module.vpc.aws_vpc.vpc: Creation complete after 3s [id=vpc-0086057259f3bfdbc]
    module.vpc.module.security_groups.data.aws_vpc.vpc: Reading...
    module.vpc.aws_internet_gateway.internet_gateway[0]: Creating...
    module.vpc.module.subnets.aws_route_table.private_subnets["data_subnet_2b"]: Creating...
    module.vpc.module.subnets.aws_subnet.private_subnets["compute_subnet_2b"]: Creating...
    module.vpc.module.subnets.aws_route_table.private_subnets["data_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_route_table.public_subnets["public_subnet_2b"]: Creating...
    module.vpc.module.subnets.aws_route_table.public_subnets["public_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_subnet.private_subnets["compute_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_subnet.public_subnets["public_subnet_2b"]: Creating...
    module.vpc.module.subnets.aws_subnet.private_subnets["data_subnet_2b"]: Creating...
    module.vpc.module.subnets.aws_route_table.public_subnets["public_subnet_2b"]: Creation complete after 0s [id=rtb-0dcafc69a5a2de072]
    module.vpc.module.subnets.aws_route_table.private_subnets["compute_subnet_2b"]: Creating...
    module.vpc.module.security_groups.data.aws_vpc.vpc: Read complete after 1s [id=vpc-0086057259f3bfdbc]
    module.vpc.module.subnets.aws_subnet.public_subnets["public_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_route_table.private_subnets["data_subnet_2a"]: Creation complete after 1s [id=rtb-01eeee938f5edfa34]
    module.vpc.module.subnets.aws_route_table.private_subnets["compute_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_route_table.private_subnets["data_subnet_2b"]: Creation complete after 1s [id=rtb-00c0850d74f05cadc]
    module.vpc.module.subnets.aws_subnet.private_subnets["data_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_route_table.public_subnets["public_subnet_2a"]: Creation complete after 1s [id=rtb-03060080418ab29b9]
    module.vpc.module.security_groups.aws_security_group.security_groups["nat_instance"]: Creating...
    module.vpc.module.subnets.aws_subnet.public_subnets["public_subnet_2b"]: Creation complete after 1s [id=subnet-0a0d70daf30957688]
    module.vpc.module.security_groups.aws_security_group.security_groups["database"]: Creating...
    module.vpc.module.subnets.aws_subnet.private_subnets["compute_subnet_2a"]: Creation complete after 1s [id=subnet-0c8dcf65ee658db04]
    module.vpc.module.security_groups.aws_security_group.security_groups["application"]: Creating...
    module.vpc.module.subnets.aws_subnet.private_subnets["compute_subnet_2b"]: Creation complete after 1s [id=subnet-006cd430434a8a86c]
    module.vpc.aws_internet_gateway.internet_gateway[0]: Creation complete after 1s [id=igw-0bcf7af1e852a9679]
    module.vpc.module.subnets.aws_subnet.private_subnets["data_subnet_2b"]: Creation complete after 1s [id=subnet-0dbb2309af36325f6]
    module.vpc.module.subnets.aws_route_table.private_subnets["compute_subnet_2b"]: Creation complete after 0s [id=rtb-02659359f8bbe0d5f]
    module.vpc.module.subnets.aws_route_table.private_subnets["compute_subnet_2a"]: Creation complete after 0s [id=rtb-0e1de42f4eb4c9b4c]
    module.vpc.module.subnets.aws_subnet.private_subnets["data_subnet_2a"]: Creation complete after 1s [id=subnet-01deaec449ab2357b]
    module.vpc.module.subnets.aws_route_table_association.private_subnets["data_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_route_table_association.private_subnets["data_subnet_2b"]: Creating...
    module.vpc.module.subnets.aws_route_table_association.private_subnets["compute_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_route_table_association.private_subnets["compute_subnet_2b"]: Creating...
    module.vpc.module.subnets.aws_subnet.public_subnets["public_subnet_2a"]: Creation complete after 1s [id=subnet-0c0d83ec6342ca0f4]
    module.vpc.module.subnets.aws_route_table_association.public_subnets["public_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_route_table_association.public_subnets["public_subnet_2b"]: Creating...
    module.vpc.aws_route.route_internet_gateway["public_subnet_2b"]: Creating...
    module.vpc.module.subnets.aws_route_table_association.private_subnets["data_subnet_2a"]: Creation complete after 0s [id=rtbassoc-0ac711b27f79f6b67]
    module.vpc.aws_route.route_internet_gateway["public_subnet_2a"]: Creating...
    module.vpc.module.subnets.aws_route_table_association.private_subnets["compute_subnet_2a"]: Creation complete after 0s [id=rtbassoc-05b9e1c2099153171]
    module.vpc.module.subnets.aws_route_table_association.private_subnets["data_subnet_2b"]: Creation complete after 0s [id=rtbassoc-00d4d60aab23b66c7]
    module.vpc.module.subnets.aws_route_table_association.public_subnets["public_subnet_2a"]: Creation complete after 0s [id=rtbassoc-092a8a33ac6106dc5]
    module.vpc.module.subnets.aws_route_table_association.public_subnets["public_subnet_2b"]: Creation complete after 0s [id=rtbassoc-07b4320c25813bd1f]
    module.vpc.module.subnets.aws_route_table_association.private_subnets["compute_subnet_2b"]: Creation complete after 0s [id=rtbassoc-0ce1f975e9caea115]
    module.vpc.aws_route.route_internet_gateway["public_subnet_2b"]: Creation complete after 0s [id=r-rtb-0dcafc69a5a2de0721080289494]
    module.vpc.aws_route.route_internet_gateway["public_subnet_2a"]: Creation complete after 0s [id=r-rtb-03060080418ab29b91080289494]
    module.vpc.module.security_groups.aws_security_group.security_groups["database"]: Creation complete after 2s [id=sg-0f78cb71c705522e4]
    module.vpc.module.security_groups.aws_security_group.security_groups["application"]: Creation complete after 2s [id=sg-0d0d4461148c49cc5]
    module.vpc.module.security_groups.aws_security_group.security_groups["nat_instance"]: Creation complete after 2s [id=sg-020e3af63be71f6bb]
    module.vpc.module.security_group_rules.data.aws_security_group.security_group_rules["application"]: Reading...
    module.vpc.module.security_group_rules.data.aws_security_group.security_group_rules["database"]: Reading...
    module.vpc.module.security_group_rules.data.aws_security_group.security_group_rules["application"]: Read complete after 0s [id=sg-0d0d4461148c49cc5]
    module.vpc.module.security_group_rules.data.aws_security_group.security_group_rules["database"]: Read complete after 0s [id=sg-0f78cb71c705522e4]
    module.vpc.module.security_group_rules.aws_security_group_rule.security_group["application_inbound_from_database_ports_3306_protocol_tcp"]: Creating...
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_outbound_to_anywhere_ports_all_protocol_all"]: Creating...
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["database_outbound_to_anywhere_ports_all_protocol_all"]: Creating...
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_inbound_from_anywhere_ports_all_protocol_all"]: Creating...
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_outbound_to_public_subnet_2a_ports_all_protocol_all"]: Creating...
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["database_inbound_from_example_terraflops_vpc_ports_3306_protocol_tcp"]: Creating...
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["database_outbound_to_anywhere_ports_all_protocol_all"]: Creation complete after 0s [id=sgrule-3833797959]
    module.vpc.module.security_group_rules.aws_security_group_rule.security_group["application_inbound_from_database_ports_3306_protocol_tcp"]: Creation complete after 0s [id=sgrule-1107615453]
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_outbound_to_anywhere_ports_all_protocol_all"]: Creation complete after 1s [id=sgrule-2889924155]
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["database_inbound_from_example_terraflops_vpc_ports_3306_protocol_tcp"]: Creation complete after 1s [id=sgrule-1369931668]
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_inbound_from_anywhere_ports_all_protocol_all"]: Creation complete after 2s [id=sgrule-866486990]
    module.vpc.module.security_group_rules.aws_security_group_rule.cidr_block["application_outbound_to_public_subnet_2a_ports_all_protocol_all"]: Creation complete after 2s [id=sgrule-1600886702]
    
    Apply complete! Resources: 31 added, 0 changed, 0 destroyed.
```