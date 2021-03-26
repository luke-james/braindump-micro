## io-quarkus-rest
# This module will define the systems required to support running our Quarkus REST API
# using Amazon Fargate, EKS & ECS.

# We will need:
# --> AWS VPC to group our compute resources.
# --> 1x Public Subnet (/w elastic IP)
# --> 1x Private Subnet (for our Fargate service)

module "io-quarkus-rest-vpc" {

  ## We want to wrap our backend services in a VPC.

  source = "./modules/aws-vpc"

  service_name = var.service_name
  description = "web"

  cidr_block = "10.0.0.0/16"
  dns_support = true
  dns_hostnames = true

}

module "app_subnets" {

  # Create a set of subnets for our backend services.

  source = "./modules/aws-subnet"

  subnets = {
    quarkus-dev = {
      
      service_name = var.service_name,
      environment = "dev",
      
      target_vpc = module.io-quarkus-rest-vpc.created_vpc,
      blocks = {
        "publicOne" = "10.0.1.0/24",
        "publicTwo" = "10.0.2.0/24", 
        "privateOne" = "10.0.3.0/24",
        "privateTwo" = "10.0.4.0/24" 
      }
    }
  }

  depends_on = [
      module.io-quarkus-rest-vpc
    ]
}

module "quarkus_security_group" {

  # Create a security group that allows our load balancers to talk
  # to our Quarkus backend application.

  source = "./modules/aws-security-group"

  vpc_id = module.io-quarkus-rest-vpc.created_vpc.id
  service_name = var.service_name
  description = "A security group to protect our Quarkus (${ var.service_name }) service."

  ingress_cidr_block = ["10.0.2.0/24"]
  egress_cidr_block = ["10.0.2.0/24"]
}

module "vpc_internet_gateway" {

  # Create an internet gatway to allow,
  # web clients to access our application.

  source = "./modules/aws-vpc/modules/aws-vpc-internet-gateway"
  vpc_id = module.io-quarkus-rest-vpc.created_vpc.id
  service_name = "${ var.service_name }"

}

module "quarkus_load_balancers" {

  # Use this module to create a public facing load balancer for our Quarkus service.
  # This load balancer will eventually feed traffic into our Quarkus/ECS container service, 
  # running on port 8080.
  
  source = "./modules/aws-elb"

  service_name = var.service_name
  id = "web"

  security_groups = [
    module.quarkus_security_group.security_group_id
    ]
  
  security_group_subnets = [
    module.app_subnets.created_subnets[0]["quarkus-dev.publicOne"].id,
    module.app_subnets.created_subnets[0]["quarkus-dev.publicTwo"].id
    ]

  instance_port = 8080
  lb_port = 80

  depends_on = [
    module.vpc_internet_gateway,
    module.app_subnets
    ]

}