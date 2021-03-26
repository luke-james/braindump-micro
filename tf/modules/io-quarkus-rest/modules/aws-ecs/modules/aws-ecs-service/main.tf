resource "aws_ecs_service" "new_service" {

  name = var.service_name

  cluster = aws_ecs_cluster.quarkus_cluster.id
  task_definition = aws_ecs_task_definition.quarkus_task_def.arn

  desired_count = 3

  iam_role = aws_iam_role.quarkus_iam.arn

  depends_on = [aws_iam_role_policy.quarkus_iam_policy]

  ordered_placement_strategy {
    type = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.quarkus_lb.arn
    container_name = "quarkus"
    container_port = 8080
  }

  placement_constraints {
    type = "memberOf"
    expression = "attributes:ecs.availability-zone in [eu-west-1]"
  }
}