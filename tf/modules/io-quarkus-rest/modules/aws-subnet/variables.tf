variable "subnets" {
  description = "Map of all subnets to be created."
  type = map
  default = {

    quarkus-app = {

      service_name = "quarkus-app",
      environment = "dev"

      target_vpc = {},

      # Subnet name & cidr_block value pair.
      blocks = {
          "publicOne" = "10.0.1.0/24",
          "publicTwo" = "10.0.2.0/24",
          "privateOne" = "10.0.3.0/24",
          "privateTwo" = "10.0.4.0/24",
      }
    }
  }
}