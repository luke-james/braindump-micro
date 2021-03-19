variable "service" {
    type = string
    description = "The service that the load balance is a part of (e.g. io-quarkus REST API)"
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