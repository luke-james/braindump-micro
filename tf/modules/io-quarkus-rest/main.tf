## io-quarkus-rest
# This module will define the systems required to support running our Quarkus REST API
# using Amazon Fargate, EKS & ECS.

# We will need:
# --> AWS VPC to group our compute resources.
# --> 1x Public Subnet (/w elastic IP)
# --> 1x Private Subnet (for our Fargate service)

# Create a private subnet for our entire Quarkus backend.
resource "aws_vpc" "io-quarkus-rest" {
  cidr_block = "10.0.0.0/16"
}

# Create a public subnet for our ELB/Load Balancers.
module "public_subnet" {

  source = "./modules/aws-subnet"

  vpc_id = aws_vpc.io-quarkus-rest.id
  service_name = var.service_name
  cidr_block = "10.0.1.0/24"
}

# Create a private subnet for our Fargate service.
module "private_subnet" {

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

# Create load balancers to handle traffic to our Quarkus service.
module "quarkus_load_balancers" {
  
  source = "./modules/aws-elb"

  service_name = var.service_name
  id = "web"
  
  availability_zones = ["eu-west-1"]

  security_groups = ["quarkus_security_group"]
  security_group_subnets = ["public_subnet"]

  instance_port = 8080
  lb_port = 80

  depends_on = ["quarkus_security_group", "public_subnet"]
}