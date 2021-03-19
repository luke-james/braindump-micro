variable "vpc_id" {
  type = string
  description = "The target VPC for this subnet to be created in."
}

variable "service_name" {
  type = string
  description = "The pretty/human-readable name for the service this subnet is part of. This will be set in the resource tags."
}

variable "cidr_block" {
  type = string
  description = "The CIDR range we want to give to our new subnet within the target VPC."
}

variable "has_internet_gateway" {
  type = bool
  description = "True if we want to create an internet gateway.  False if not."
  default = false
}