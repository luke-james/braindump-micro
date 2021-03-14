## This script will create an S3 Backend for our Terraform Deployments.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}

# We only need one variable for this deployment, which dictates where we are deploying the state file.
variable "AWS_REGION" {
  type = string
  default = "eu-west-1"
}

provider "aws" {
  region = var.AWS_REGION
}

resource "random_string" "bucket_randomizer" {
  length = 8
  special = false
  lower = true
  upper = false
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up-and-running-state-${ random_string.bucket_randomizer.result }"

  # Enable versioning so we can see history of state files.
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default.
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}