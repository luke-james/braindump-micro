resource "aws_eip" "elastic_ip" {

    instance = var.target_instance
    vpc = true
}