module "iam-policy" {
 
    # Creates a policy that will allow ECS to register instances with an ELB target group.

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "3.14.0"

  name = "AllowECSToRegisterInstancesWithELBTargetGroups"

  description = "This policy allows an ECS service to register container instances with an ELB target group, allowing us to filter traffic to new instances within our Quarkus cluster."

  path = "/"
  policy = file("${ path.module }/allow-ecs-to-update-elb-policy.json")
}

module "iam_iam-assumable-role" {

    # Creates a role that our ECS service can assume that will have the permissions attached
    # to allow our ECS service to register container instance with our ELB target groups.

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "3.14.0"

  create_role = true

  role_name = "RegisterECSInstanceWithLoadBalancerTarget"
  
  trusted_role_services = [
      "ecs.amazonaws.com"
  ]

  trusted_role_actions = [
      "sts:AssumeRole"
  ]

  custom_role_policy_arns = [
      module.iam-policy.arn
  ]
}