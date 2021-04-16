data "aws_iam_policy" "ecs_task_execution_policy" {

    # Fetches existing ECS Task execution policy that we can attach later to a new role we are creating.

    arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_execution_role" {

    # Creates a new Role to handle our ECS task execution.
    # We want our ECS cluster to be able to spawn new containers from ECR images.

    name               = "ecsTaskExecutionRole"
    path               = "/service-role/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ecs.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-ecs_task_execution_policy_attachment" {

    # Attaches existing Policy to our new Role.

    role       = aws_iam_role.ecs_task_execution_role.name
    policy_arn = data.aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_ecr_repository" "repository" {
    
    # Creates a container repository for our software to be deployed from.
    
    name = "${ var.env }-${ var.service }-repo"
}

resource "aws_ecs_cluster" "cluster" {
    
    # Creates an ECS cluster for our services & task defs to be deployed into.
    
    name = "${ var.env }-${ var.service }-ecs-cl"
    tags = {
        Service = var.service
        Environment = var.env
    }
}

resource "aws_ecs_task_definition" "task_def" {

    # Creates a task definition based off a given configuration.

    family = "${ var.env }-${ var.service }-ecs-tsk-def"

    container_definitions = file("${ path.module }/braindump-ecs-task-definitions.json")
    
    ## FARGATE SPECIFIC SETTINGS BELOW!!
    
    requires_compatibilities = [ "FARGATE" ]
    network_mode = "awsvpc"

    cpu = 1024 # 1vCPU
    memory = 2048 # 2GB

    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "service" {
    
    # Creates an ECS service for our backend to run.
    
    name = "${ var.env }-${ var.service }-ecs-srv"
    
    cluster = aws_ecs_cluster.cluster.arn
    task_definition = aws_ecs_task_definition.task_def.arn
    
    iam_role = "arn:aws:iam::533462699161:role/RegisterECSInstanceWithLoadBalancerTarget"
    desired_count = var.desired_count

    ordered_placement_strategy {
        type = "binpack"
        field = "cpu"
    }

    load_balancer {
        target_group_arn = var.load_balancer_arn
        container_name = "${ var.env }-${ var.service }"
        container_port = var.load_balancer_port
    }

    placement_constraints {
        type = "memberOf"
        expression = "attribute:ecs.availability-zone in [${ join(", ", var.geo_locations) }]"
    }
}

