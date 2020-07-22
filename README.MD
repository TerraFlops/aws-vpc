# Terraflops Terraform Modules

**Warning:** This repository is not fit for human consumption, it is developed for internal purposes
only, if you get any benefit out of it- feel free to use it, however no support is offered.
 
### AWS Virtual Private Cloud

This module creates an AWS VPC along with the following optional components:

* Subnets
* Security Groups
* Security Group Rules
* Internet Gateway
* NAT 
    * Native AWS NAT Gateway
    * Cost-Saving EC2 NAT Instances + Associated Security Group Rules

### Examples

For an example of using this component, refer to the README.MD file in the examples folder. 

### Important Note: NAT Instance Security Group Rules

When creating a NAT instance it is necessary to specify a security group which will be added to the created
EC2 instance(s). The rules required by this security will be automatically created, do not attempt to
manually create these rules or you will receive conflicts during deployment. 
