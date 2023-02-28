# this is the main deployment modules
# this should marshall all dependent module (plus any extra bits of glue)
# propogate the basic deploy name, environment, version, unique_name details 
# and add in any specific config needed for child modules


# module "lambda" {
#   source      = "git@github.com:ucl-isd/easikit-terraform-lambda.git//module"

#   # output variable from the above module
#   sns_publishers         = local.sns_map          # (see module and locals above)

#   # the propogated from the terraform.tfvars.json config element, all mandatory
#   func_name             = local.config.name         # (defined in the target tfvars)
#   image_ecr             = local.config.image_ecr    # (defined in the target tfvars)
#   image_repo            = local.config.image_repo   # (defined in the target tfvars)

#   # the propogated from the terraform.tfvars.json config element, can be omitted
#   public                = local.config.public       # (defined in the module tfvars)
#   env_vars              = local.env_vars            # (combination of module and target)

#   # core variables, from variables.tf, always just here
#   name        = var.name
#   env         = var.env
#   vrsn        = var.vrsn
# }

# locals {
#   lambda_map = {
#     lambda = {
#       lambda_name       = module.lambda.lambda_function_name
#       lambda_invoke_arn = module.lambda.lambda_function_invoke_arn
#       http_method       = local.config.test_endpoint.http_method    # (from module tfvars)
#       resource_path     = local.config.test_endpoint.resource_path  # (from module tfvars)
#     }
#     # ...
#   }
# }


# module "gateway" {
#   source      = "git@github.com:ucl-isd/easikit-terraform-api-gateway.git//module"

#   # output variables from the lambda modules
#   lambda_functions      = local.lambda_map           # (required)

#   # the propogated from the terraform.tfvars.json config element
#   domain_name           = local.config.domain_name   # (from target tfvars)
#   context_path          = local.config.context_path  # (from module tfvars)
#   api_version           = local.config.api_version   # (from target tfvars)
#   authoriser            = local.config.authoriser    # (from target tfvars)

#   # core variables, from variables.tf, always just here
#   name        = var.name
#   env         = var.env
#   vrsn        = var.vrsn
# }

resource "aws_ecs_cluster" "data-sync-cluster" {
  name = "${var.environment}-${var.name}-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "data-sync-cluster-capacity-provider" {
  cluster_name = aws_ecs_cluster.data-sync-cluster.name
  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }
}


resource "aws_ecs_task_definition" "main" {
  family = "${var.environment}-${var.name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([{
    name        = "${var.name}-container-${var.environment}",
    image       = "${var.image}",
    essential   = true,
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port,
      hostPort      = var.container_port
    }]

  }])

  tags = {
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }
}



