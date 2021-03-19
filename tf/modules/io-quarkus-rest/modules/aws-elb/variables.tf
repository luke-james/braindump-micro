variable "service_name" {
    type = string
    description = "The service that the load balance is a part of (e.g. io-quarkus REST API)"
}

variable "security_groups" {
    type = list(string)
    description = "A list of security groups for our load balancer."
}

variable "security_group_subnets" {
    type = list(string)
    description = "A list of subnets for our ELB (required if using a VPC)."
}

variable "id" {
    type = string
    description = "An identifier for the load balancer.  This could be anything including the 'layer' it resides in the system (i.e. web)"
}

variable "instance_port" {
    type = number
    description = "The port our target instances are listening on.  Our load balancer will forward traffic to our instances on this port."
    default = 80
}

variable "lb_port" {
    type = number
    description = "The port our load balancers are listening for traffic on."
    default = 80
}