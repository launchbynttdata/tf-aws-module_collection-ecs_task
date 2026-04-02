# ============================================
# CORE VARIABLES
# ============================================

tags = {
  Example = "ECS Task Custom Policies Example"
  Owner   = "Terraform"
}

# ============================================
# ECS TASK CONFIGURATION
# ============================================

ecs_task_family = "example-ecs-task-custom-policies"
ecs_task_cpu    = "512"
ecs_task_memory = "1024"

# ============================================
# CUSTOM POLICY STATEMENTS
# These are the ONLY policies that will be created and attached to the task role.
# No auto-generated policies (CloudWatch, SSM, S3, EFS, KMS, AppConfig) are attached.
# ============================================

task_role_policy_statements = {
  CustomS3ReadAccess = {
    sid     = "CustomS3ReadAccess"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket", "s3:GetBucketLocation"]
    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*"
    ]
  }
  CustomSSMParamRead = {
    sid     = "CustomSSMParamRead"
    effect  = "Allow"
    actions = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
    resources = [
      "arn:aws:ssm:*:*:parameter/*"
    ]
  }
}

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
}

# ============================================
# RESOURCE NAME MODULE VARIABLES
# ============================================

logical_product_family        = "demo_org"
logical_product_service       = "ecs_task"
region                        = "us-east-2"
class_env                     = "dev"
instance_env                  = 1
cloud_resource_type_execution = "executionrole"
cloud_resource_type_task      = "taskrole"
cloud_resource_type_policy    = "taskpolicy"
instance_resource             = 1
maximum_length                = 60
separator                     = "-"
