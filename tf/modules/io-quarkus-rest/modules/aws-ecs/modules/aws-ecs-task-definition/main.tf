resource "aws_ecs_task_definition" "new_task_def" {

    family = var.service_name

    container_definitions = jsonencode(var.container_definitions)

    volume {
        name = "${ var.service_name }-${ var.environment }-storage"
        host_path = "/ecs/${ var.service_name }-${ var.environment }-storage"
    }

    placement_constraints {
        type = "memberOf"
        expression = "attribute:ecs.availability-zone in ${ var.geo-locations }"
    }
}