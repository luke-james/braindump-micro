
module "quarkus_infrastructure" {

    source = "./modules/backend-access-security-networking"

    service = var.service
    env = var.env

    vpc_cidr_block = "10.0.0.0/16"

    public_subnets = "10.0.1.0/24"
    private_subnets = "10.0.3.0/24"
}

module "container_compute_resources" {

  ## This module will create a set of ECS resources to handle our Quarkus application.

  source = "./modules/containers"
  
  service = var.service
  env = var.env
  
  load_balancer_arn = module.quarkus_infrastructure.load_balancer_target_group_arn
  load_balancer_port = module.quarkus_infrastructure.load_balancer_port

  geo_locations = [
    "eu-west-1"
  ]

  depends_on = [
    module.quarkus_infrastructure
  ]
}