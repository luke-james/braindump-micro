variable "vpc_id" {
    type = string
    description = "VPC ID we want our internet gateway to be deployed into."
}

variable "service_name" {
    type = string
    description = "Name to be set in the AWS Tags."
}