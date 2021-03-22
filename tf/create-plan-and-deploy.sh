#!/bin/bash

# Initialize Terraform
terraform init

# Create Terraform Plan
terraform plan -out main.tfplan

# Deploy Plan
terraform apply -auto-approve
