# ============================================
# CORE VARIABLES
# ============================================

tags = {
  Example = "ECS Task Collection Module"
  Owner   = "Terraform"
}

# ============================================
# ECS TASK CONFIGURATION
# ============================================

ecs_task_family = "example-ecs-task-family"


# ============================================
# CONTAINER CONFIGURATION
# ============================================

container_name  = "nginx"
container_image = "nginx:latest"
container_environment = [
  {
    name  = "EXAMPLE_ENV_VAR"
    value = "example-value"
  }
]
container_port_mappings = [
  {
    containerPort = 80
    hostPort      = 80
    protocol      = "tcp"
  }
]

# ============================================
# RESOURCE NAME MODULE VARIABLES
# ============================================

logical_product_family        = "demo_org"
logical_product_service       = "ecs_task"
region                        = "us-east-2"
class_env                     = "dev"
instance_env                  = 0
cloud_resource_type_execution = "executionrole"
cloud_resource_type_task      = "taskrole"
cloud_resource_type_policy    = "taskpolicy"
instance_resource             = 0
maximum_length                = 60
separator                     = "-"

