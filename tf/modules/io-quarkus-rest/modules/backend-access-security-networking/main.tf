locals {
  
    load_balancer_instance_port = 8080
}

resource "aws_vpc" "quarkus_backend" {

    # This VPC will contain our Load Balancers, Compute Resources & Databases
    # for our Quarkus/Braindump service.
    
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default" # e.g. Shared Tenancy

    # DNS support uses a Route 53 resolver that resolves public DNS hostnames to VPC IP addresses.
    enable_dns_support = true

    # DNS hostnames give public IP addresses, public DNS hostnames.
    # e.g. ec2-public-ipv4-address.compute-1.amazonaws.com
    enable_dns_hostnames = true

    tags = {
        Service = var.service
        Environment = var.env
    }
}

resource "aws_security_group" "allow_quarkus_backend_rest_traffic" {

    # This security group creates a rule to allow TCP traffic on port 80
    # to be communicated within the VPC.

    name = "${ var.env }-${ var.service }-sg"
    description = "Allow inbound traffic for our Quarkus REST service."
    
    vpc_id = aws_vpc.quarkus_backend.id

    ingress {
        
        description = "Traffic from VPC"
        
        cidr_blocks = [
            aws_vpc.quarkus_backend.cidr_block
        ]
        
        from_port = 80
        to_port = 80
        protocol = "tcp"

    }

    egress {
        
        cidr_blocks = [
            aws_vpc.quarkus_backend.cidr_block
        ]
        
        from_port = 80
        to_port = 80
        protocol = "tcp"

    }

    tags = {
        Service = var.service
        Environment = var.env
    }
}

resource "aws_subnet" "quarkus_public_subnets" {

    #for_each = toset( var.public_subnets )

    vpc_id = aws_vpc.quarkus_backend.id
    cidr_block = var.public_subnets

    tags = {
        Service = var.service
        Environment = var.env
        Type = "Public"
    }
}

resource "aws_subnet" "quarkus_private_subnets" {

    #for_each = toset( var.private_subnets )

    vpc_id = aws_vpc.quarkus_backend.id
    cidr_block = var.private_subnets

    tags = {
        Service = var.service
        Environment = var.env
        Type = "Private"
    }
}

resource "aws_eip" "quarkus_public_ip" {

    # We need a public IP for our load balancing service to receive requests on.

    vpc = true
    tags = {
        Service = var.service
        Environment = var.env
    }
}

resource "aws_internet_gateway" "quarkus_gateway" {

    # We need an internet gateway for our REST traffic to access our service.

    vpc_id = aws_vpc.quarkus_backend.id
    tags = {
        Service = var.service
        Environment = var.env
    }
}

resource "aws_lb" "quarkus_front_end" {

    # We want to create a network load balancer with a public IP 
    # that will handle forwarding our traffic to our Fargate service.

    name = "${ var.env }-${ var.service }-nlb"
    load_balancer_type = "network"
    
    enable_deletion_protection = false

    subnet_mapping {
        subnet_id = aws_subnet.quarkus_public_subnets.id
        allocation_id = aws_eip.quarkus_public_ip.id
    }

    tags = {
        Service = var.service
        Environment = var.env
    }
}

resource "aws_lb_target_group" "quarkus_front_end" {

    ## Create a target group for our Fargate instances to register to.

    name = "${ var.env }-${ var.service }-lb-tg"

    port = local.load_balancer_instance_port
    protocol = "TCP"

    vpc_id = aws_vpc.quarkus_backend.id

    tags = {
        Service = var.service
        Environment = var.env
    }
}

resource "aws_lb_listener" "quarkus_front_end" {

    ## Create a LB listener that will forward HTTP/80 requests to our Fargate service.

    load_balancer_arn = aws_lb.quarkus_front_end.arn
    
    port = 80
    protocol = "TCP"
    
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.quarkus_front_end.arn
    }
}