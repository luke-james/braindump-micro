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
}

# Create a private subnet for our Fargate service.
module "private_subnet" {
  source = "./modules/aws-subnet"
}