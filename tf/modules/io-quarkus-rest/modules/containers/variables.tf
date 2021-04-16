variable "service" {
    type = string
    description = "The name of the application/service."
}

variable "env" {
    type = string
    description = "The build of the application/service (e.g. dev)."
}

variable "geo_locations" {
    type = list(string)
    description = "A list of AWS regions that ECS will deploy into."
}

variable "load_balancer_arn" {
    type = string
    description = "The AWS ARN for an existing load balancer for our ECS service to join the target group of."
}

variable "load_balancer_port" {
    type = number
    description = "The port number our existing load balancer is forwarding traffic on to our ECS service."
}