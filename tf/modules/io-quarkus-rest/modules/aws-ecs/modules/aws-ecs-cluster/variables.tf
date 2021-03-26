variable "service_name" {
    type = string
    description = "The display name of the service for the new cluster."
}

variable "environment" {
    type = string
    description = "The identify for the environment type (e.g. dev, prod etc.)"
    default = "dev"
}