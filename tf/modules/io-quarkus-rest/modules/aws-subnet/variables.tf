variable "from_port" {
  type = number
  default = 80
}

variable "to_port" {
  type = number
  default = 80
}

variable "protocol" {
  type = string
  default = "tcp"
}