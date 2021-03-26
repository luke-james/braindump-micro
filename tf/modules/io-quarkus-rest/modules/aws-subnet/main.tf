##
# This module allows us to reuse the creation of AWS Subnets
#

locals {
  
  # Flatten the subnets data structure to produce a flat list of objects, 
  # rather than a map that contains a list (e.g. CIDR block) for each object.

  flat_subnets = flatten([
    for app, app_subnets in var.subnets : [
      for subnet_name, cidr_block in app_subnets.blocks: {
        
        app = app
        vpc = app_subnets.target_vpc

        env = app_subnets.environment
        service_name = app_subnets.service_name

        subnet_name = subnet_name
        cidr_block = cidr_block
      }
    ]
  ])
}

resource "aws_subnet" "create_subnets" {

  # This module is designed to be reused, so we will pass in a map of subnet data and create a subnet for each.

  for_each = {
    for subnet in local.flat_subnets: "${ subnet.app }.${ subnet.subnet_name }" => subnet
  }

  vpc_id = each.value.vpc.id
  cidr_block = each.value.cidr_block

  tags = {
    Name = "${ each.value.service_name }-${ each.value.env }-${ each.value.subnet_name }"
  }
}