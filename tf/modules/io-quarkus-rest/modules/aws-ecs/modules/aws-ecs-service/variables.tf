variable "service_name" {
    type = string
    description = "The name of the service/product this ECS service will be part of."
}

variable "environment" {
    type = string
    description = "An identifier for the type of environment being deployed (e.g. dev, build, prod, etc.)"
}

variable "cluster" {
    type = string
    description = "ARN of a target ECS cluster."
}

variable "task_def" {
    type = string
    description = "ARN of an existing ECS task definition."
}

variable "iam_policy" {
    type = string
    description = "ARN of a dependant IAM policy that must be present before this ECS service is created."
}

variable "load_balancer" {
    type = map
    description = "ARN of the listening load balancer instance."
    
    default = {
        arn = ""
        port = 8080
    }
}

variable "geo_locations" {
    type = list(string)
    description = "List of locations where the ECS service should be running (i.e. eu-west-1)"
    default = ["eu-west-1"]
}


