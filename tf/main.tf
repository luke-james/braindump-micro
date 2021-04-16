
# Let's set up Terraform/AWS dependencies.
terraform {

  backend "s3" {

    bucket = "terraform-up-and-running-state-tjdlt03g"
    key = "s3/tf.state" ## --> terraform.tfstate file is written to this key e.g. s3:::braindump-tfstate-bucket/tf.key
    region = "eu-west-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }

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
  
  service = "braindump-quarkus"
  env = "dev"
}