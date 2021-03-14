variable "vpc_id" {
  type = string
  description = "The AWS ID of a VPC resource you wish to use as a target for the new security group."
}

variable "service_name" {
  type = string
  description = "The AWS name you want to give your new VPC Security Group."
}

variable "description" {
  type = string
  default = "A basic security group for a VPC."
  description = "The AWS description you want to give your new VPC Security Group."
}

variable "ingress_cidr_block" {
  type = list(string)
  description = "Allowed incoming address range (IPv4)."
}

variable "ingress_from_port" {
  type = number
  default = 80
  description = "Allowed source port for incoming traffic data."
}

variable "ingress_to_port" {
  type = number
  default = 80
  description = "Allowed destination port for incoming traffic data."
}

variable "ingress_protocol" {
  type = string
  default = "tcp"
}

variable "egress_cidr_block" {
  type = list(string)
  description = "Allowed outgoing address range (IPv4)."
}

variable "egress_from_port" {
  type = number
  default = 80
  description = "Allowed source port for outbound traffic data."
}

variable "egress_to_port" {
  type = number
  default = 80
  description = "Allowed destination port for outbound traffic data."
}

variable "egress_protocol" {
  type = string
  default = "tcp"
}