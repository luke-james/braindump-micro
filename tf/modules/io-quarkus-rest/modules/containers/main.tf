
module "quarkus_role_register_lb" {

    # This module will allow an ECS service to register container instances with it's associated 
    # load balancer (Elastic Load Balancers)

    source = "./modules/load-balancing-iam-rules"
}

module "ecs_quarkus" {

    # This module will create our container services, allowing them to register with our 
    # load balancer when they come online.

    source = "./modules/container-infrastructure-ecs"

    service = var.service
    env = var.env

    geo_locations = var.geo_locations

    load_balancer_role_arn = module.quarkus_role_register_lb.created_ecs_role_arn
    load_balancer_arn = var.load_balancer_arn
    load_balancer_port = var.load_balancer_port

    depends_on = [
        module.quarkus_role_register_lb
    ]
}