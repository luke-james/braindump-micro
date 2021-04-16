variable "service" {
    type = string
    description = "The name of the service we are deploying for."
}

variable "env" {
    type = string
    description = "The build of our environment."
    default = "dev"  
}

variable "vpc_cidr_block" {
    type = string
    description = "The CIDR block we want for our new VPC."
    default = "10.0.0.0/16"
}

variable "public_subnets" {
    type = string
    description = "The list of IPv4 address ranges (CIDR format), we want for our public subnets."
    #default = [
    #    "10.0.1.0/24",
    #    "10.0.2.0/24"
    #]
}

variable "private_subnets" {
    type = string
    description = "The list of IPv4 address ranges (CIDR format), we want for our public subnets."
    #default = [
    #    "10.0.3.0/24",
    #    "10.0.4.0/24"
    #]
}