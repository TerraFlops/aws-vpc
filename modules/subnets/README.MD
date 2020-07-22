# Subnets
 
This module is responsible for creating the subnets in the VPC.

## Variables

* `vpc_id`
   
  The AWS resource ID of the VPC into which these subnets will be created (e.g. `vpc-c1a2f3e4b5e6e7f`)

* `public_subnets`

  A map of public subnets to be created. Public subnets are those which have a default route out via the Internet
  Gateway. The key used in the map should denote a unique identifier which will be used in all other Terraflops
  templates to identify this subnet (e.g. `public_subnet_2a`, `data_subnet_2b`). The value of each item is an object
  consisting of the following properties:
  
  * `subnet_type`
  
    The subnet type should be a single word describing the purpose of the subnet (e.g. `public`, `database`, `compute`)
  
  * `cidr_block`
  
    The CIDR block to be assigned to this subnet. This must not overlap with any other subnet in the VPC, and must
    fit within the range defined for the supplied VPC
  
  * `availability_zone`

    The AWS availability zone ID in which the subnet will be created (e.g. `ap-southeast-2a`)

  If no public subnets exist this parameter can be omitted.

* private_subnets

  A map of private subnets to be created. Private subnets are those with no direct route out via the Internet
  Gateway, if internet access is required in these subnets it must be via the use of either a native AWS NAT gateway
  or EC2 NAT instances.
  
  The structure of this variable is identical to the `public_subnets` above.

  If no private subnets exist this parameter can be omitted.

## Example Usage

The following example will create four subnets in the VPC with ID `vpc-c1a2f3e4b5e6e7f` (not created
in the scope of this example- but is assumed to have a CIDR of 10.0.0.0/18)

* VPC (10.0.0.0/18)  
    * Availability Zone 2A (ap-southeast-2a)
        * Public Subnet (10.0.10.0/24)
        * Compute Subnet (10.0.20.0/24)
    * Availability Zone 2B (ap-southeast-2b)
        * Public Subnet (10.0.11.0/24) 
        * Compute Subnet (10.0.21.0/24) 

```hcl-terraform
module "subnets" {
  source = "./modules/subnets"
  vpc_id = 'vpc-c1a2f3e4b5e6e7f'

  public_subnets = {
    public_subnet_2a = {
      subnet_type = 'public'
      cidr_block = '10.0.10.0/24'
      availability_zone = 'ap-southeast-2a'
    },
    public_subnet_2b = {
      subnet_type = 'public'
      cidr_block = '10.0.11.0/24'
      availability_zone = 'ap-southeast-2b'
    }  
  }
  private_subnets = {
    compute_subnet_2a = {
      subnet_type = 'compute'
      cidr_block = '10.0.20.0/24'
      availability_zone = 'ap-southeast-2b'
    },
    compute_subnet_2b = {
      subnet_type = 'compute'
      cidr_block = '10.0.21.0/24'
      availability_zone = 'ap-southeast-2b'
    }
  }
}
```