##
# This module allows us to reuse the creation of AWS Subnets
#

# Create a new subnet.
resource "aws_subnet" "new_subnet" {

  # This module is designed to be reused, so we will pass in a target VPC, which has a defined CIDR range for IPv4 addresses.
  # We will also pass in the CIDR range we would like to use within the target VPC.

  vpc_id = var.vpc_id
  cidr_block = var.cidr_block

  tags = {
    Name = var.service_name
  }
}