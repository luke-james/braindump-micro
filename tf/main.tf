
# Let's set up Terraform/AWS dependencies.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
variable "AWS_REGION" {
  type = string
}

# Configure AWS Provider
provider "aws" {
  region = var.AWS_REGION
}

# Create our Quarkus REST Service
module "io-quarkus-brain-dump-micro" {
  source       = "./modules/io-quarkus-rest"
  service_name = "io-quarkus-brain-dump-micro"
}