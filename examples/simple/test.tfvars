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
ecs_task_cpu    = "512"
ecs_task_memory = "1024"


# ============================================
# CONTAINER CONFIGURATION
# ============================================

container_definitions = {
  nginx = {
    name  = "nginx"
    image = "nginx:latest"
    environment = [
      {
        name  = "EXAMPLE_ENV_VAR"
        value = "example-value"
      }
    ]
    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
    essential = true
  }
  sidecar = {
    name   = "sidecar"
    image  = "busybox:latest"
    cpu    = 128
    memory = 256
    environment = [
      {
        name  = "SIDECAR_ENV_VAR"
        value = "sidecar-value"
      }
    ]
    essential = false
  }
}

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
