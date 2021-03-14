# Create security rules for a given VPC.
resource "aws_security_group" "allow_rest_traffic" {

  name = var.service_name + "-" + var.description + "-security-group"
  description = "Allow inbound traffic for our REST services."
  vpc_id = var.vpc_id

  ingress {
    description = "Traffic from VPC"
    cidr_blocks = [var.ingress_cidr_block]
    from_port = var.ingress_from_port
    protocol = var.ingress_protocol
    to_port = var.ingress_to_port
  }

  egress {
    from_port = var.egress_from_port
    protocol = var.egress_protocol
    to_port = var.egress_to_port
    cidr_blocks = [var.egress_cidr_block]
  }
}