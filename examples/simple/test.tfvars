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
