resource "aws_ecs_service" "new_service" {

  name = var.service_name

  cluster = var.cluster.arn
  task_definition = var.task_def.arn

  desired_count = var.desired_count

  iam_role = var.iam_role.arn

  ordered_placement_strategy {
    type = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = var.load_balancer["arn"]
    container_name = var.service_name
    container_port = var.load_balancer["port"]
  }

  placement_constraints {
    type = "memberOf"
    expression = "attributes:ecs.availability-zone in ${ var.geo_locations }"
  }
}