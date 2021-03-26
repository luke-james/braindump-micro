resource "aws_ecs_cluster" "new_cluster" {
    
    name = "${ var.service_name }-${ var.environment }-ecs-cluster"

    tags = {
        service = ${ var.service_name }
        environment = ${ var.environment }
    }

}