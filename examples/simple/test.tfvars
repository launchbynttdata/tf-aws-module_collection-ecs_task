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
    mountPoints = [
      {
        sourceVolume  = "efs-volume"
        containerPath = "/app/data"
        readOnly      = false
      }
    ]
    essential              = true
    readOnlyRootFilesystem = true
    linuxParameters = {
      tmpfs = [
        {
          containerPath = "/tmp"
          size          = 64
          mountOptions  = ["defaults", "rw", "mode=1777"]
        }
      ]
    }
    healthCheck = {
      command = [
        "CMD-SHELL",
        "curl -f http://localhost/ || exit 1"
      ]
      interval    = 30
      timeout     = 15
      retries     = 1
      startPeriod = 30
    }
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

volumes = [
  {
    name = "efs-volume"
    efs_volume_configuration = {
      file_system_id = "fs-12345678"
      root_directory = "/"
    }
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
