## io-quarkus-rest
# This module will define the systems required to support running our Quarkus REST API
# using Amazon Fargate, EKS & ECS.

# We will need:
# --> AWS VPC to group our compute resources.
# --> 1x Public Subnet (/w elastic IP)
# --> 1x Private Subnet (for our Fargate service)

module "io-quarkus-rest-vpc" {

  ## This module will create a basic VPC to contain our backend services.


  source = "./modules/aws-vpc"

  service_name = var.service_name
  description = "web"

  cidr_block = "10.0.0.0/16"
  dns_support = true
  dns_hostnames = true

}

# Create a public subnet for our ELB/Load Balancers.
module "public_subnet_one" {

  source = "./modules/aws-subnet"

  vpc_id = module.io-quarkus-rest-vpc.id
  service_name = var.service_name
  cidr_block = "10.0.1.0/24"
}

# Create a private subnet for our Fargate service.
module "private_subnet_one" {

  source = "./modules/aws-subnet"

  vpc_id = aws_vpc.io-quarkus-rest.id
  service_name = var.service_name
  cidr_block = "10.0.2.0/24"
}

# Create a security group for our backend services to protect against the outside world.
module "quarkus_security_group" {

  source = "./modules/aws-security-group"

  vpc_id = aws_vpc.io-quarkus-rest.id
  service_name = var.service_name
  description = "A security group to protect our Quarkus (${ var.service_name }) service."

  ingress_cidr_block = ["10.0.2.0/24"]
  egress_cidr_block = ["10.0.2.0/24"]
}

  # Create an internet gateway, to allow clients to communicate with our infrastructure.
module "vpc_internet_gateway" {

  source = "./modules/aws-vpc-internet-gateway"
  vpc_id = aws_vpc.io-quarkus-rest.id
  service_name = "${ var.service_name }"

}

# Create load balancers to handle traffic to our Quarkus service.
module "quarkus_load_balancers" {
  
  source = "./modules/aws-elb"

  service_name = var.service_name
  id = "web"

  security_groups = [
    module.quarkus_security_group.security_group_id
    ]
  
  security_group_subnets = [
    module.public_subnet.subnet_id
    ]

  instance_port = 8080
  lb_port = 80

  depends_on = [
    module.vpc_internet_gateway
    ]

}