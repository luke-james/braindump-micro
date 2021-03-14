# Create a new subnet.
resource "aws_subnet" "subnet" {
  vpc_id = var.vpc_id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = var.service_name
  }
}

# Create security rules for this subnet.
resource "aws_security_group" "security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    cidr_blocks = [aws_vpc.main.cidr_block]
    from_port = var.from_port
    protocol = var.protocol
    to_port = var.to_port
  }
}