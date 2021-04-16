  output "load_balancer_target_group_arn" {
      value = aws_lb.quarkus_front_end.arn
  }

  output "load_balancer_port" {
      value = local.load_balancer_instance_port
  }