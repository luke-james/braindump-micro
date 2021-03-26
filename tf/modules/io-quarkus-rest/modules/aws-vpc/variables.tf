variable "service_name" {
    type = string
    description = "The name of the service to be used as part of the tags."
} 

variable "description" {
    type = string
    description = "A short description/id for the service to be used as part of the tags."
}

variable "cidr_block" {
    type = string
    description = "CIDR block of IPv4 addresses to allocate for this VPC (e.g. 10.0.0.0/16)."
} 

variable "instance_tenancy" {
    type = string
    default = "default"
    description = "Default == Shared Tenancy (Dedicated or Host are other options and cost at least $2 an hour)."
}

variable "dns_support" {
    type = bool
    default = false
    description = "Indicates whether or not to resolve DNS names to public IP addresses using Route53 resolver."
}

variable "dns_hostnames" {
    type = bool
    default = false
    description = "Indicates whether or not to use public DNS hostnames for public IPv4 addresses."
}