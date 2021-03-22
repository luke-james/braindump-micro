
###
# This module creates a basic VPC resource in AWS.;

resource "aws_vpc" "main" {
    
    cidr_block = var.cidr_block
    instance_tenancy = var.instance_tenancy

    # DNS support uses a Route 53 resolver that resolves public DNS hostnames to VPC IP addresses.
    enable_dns_support = var.dns_support

    # DNS hostnames give public IP addresses, public DNS hostnames.
    # e.g. ec2-public-ipv4-address.compute-1.amazonaws.com
    enable_dns_hostnames = var.dns_hostnames

    tags = {
        name = "${ var.service_name }-${ var.description }-vpc"
    }
}