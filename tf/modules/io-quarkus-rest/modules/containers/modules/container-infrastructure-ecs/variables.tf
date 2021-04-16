variable "service" {
    type = string
    description = "The name of our service/app."
}

variable "env" {
    type = string
    description = "The build of our service/app (e.g. dev)."
}

variable "geo_locations" {
    type = list(string)
    description = "A list of AWS AZs that our ECS infrasturcture will be deployed into."
    default = [
        "eu-west-1"
    ]
}

variable "load_balancer_role_arn" {
    type = string
    description = "The AWS ARN of an active IAM role, with policy permissions that allow a new ECS service to register instances with load balancers."
}

variable "desired_count" {
    type = number
    description = "The desired number of containers we want by default"
    default = 1
}

variable "load_balancer_arn" {
    type = string
    description = "The AWS Arn for our Load Balancer."
}

variable "load_balancer_port" {
    type = number
    description = "The port number that our load balancer is expecting our container to be accepting traffic on. (e.g. 8080)"
}