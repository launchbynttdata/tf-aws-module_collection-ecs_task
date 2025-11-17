# ============================================
# VALIDATION
# This prevents invalid configurations like:

# Creating neither role nor providing ARNs
# Trying to both create a role AND provide an existing ARN for the same role
# ============================================

resource "terraform_data" "role_validation" {
  lifecycle {
    precondition {
      condition = (
        var.create_execution_role ||
        var.execution_role_arn != null
        ) && (
        var.create_task_role ||
        var.task_role_arn != null
      )
      error_message = "Either create role flags must be true, or role ARNs must be provided for both execution and task roles."
    }

    precondition {
      condition = !(
        (var.create_execution_role && var.execution_role_arn != null) ||
        (var.create_task_role && var.task_role_arn != null)
      )
      error_message = "Do not provide both create role flags and role ARNs for the same role. Choose one: create role or provide ARN."
    }
  }
}

# ============================================
# ECS TASK EXECUTION ROLE
# ============================================

module "ecs_task_execution_role" {
  count  = var.create_execution_role ? 1 : 0
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-iam_role.git?ref=0.1.0"

  # Role configuration
  name               = var.execution_role_name != null ? var.execution_role_name : "${var.ecs_task_family}-execution"
  description        = var.execution_role_description
  path               = var.path != null ? var.path : "/"
  assume_role_policy = local.ecs_task_execution_role_policy

  # Tags
  tags = merge(
    local.common_tags,
    {
      Name = var.execution_role_name != null ? var.execution_role_name : "${var.ecs_task_family}-execution"
    }
  )
}

module "ecs_task_execution_custom_access_policy" {
  count  = var.create_execution_role && length(local.execution_custom_policies) > 0 ? 1 : 0
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-iam_policy.git?ref=0.1.0"

  policy_name      = var.execution_policy_name
  policy_statement = local.execution_custom_policies
  tags             = local.common_tags
}

# Attach secret access policy to execution role
module "ecs_task_execution_custom_access_policy_attachment" {
  count  = var.create_execution_role && length(local.execution_custom_policies) > 0 ? 1 : 0
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-iam_role_policy_attachment.git?ref=0.1.0"

  role_name  = module.ecs_task_execution_role[0].role_name
  policy_arn = module.ecs_task_execution_custom_access_policy[0].policy_arn
}

# ============================================
# ECS TASK ROLE
# ============================================
module "ecs_task_role" {
  count  = var.create_task_role ? 1 : 0
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-iam_role.git?ref=0.1.0"

  # Role configuration
  name               = var.task_role_name != null ? var.task_role_name : "${var.ecs_task_family}-task"
  description        = var.task_role_description
  path               = var.path != null ? var.path : "/"
  assume_role_policy = local.ecs_task_execution_role_policy

  # Tags
  tags = merge(
    local.common_tags,
    {
      Name = var.task_role_name != null ? var.task_role_name : "${var.ecs_task_family}-task"
    }
  )
}

# ECS TASK ROLE CUSTOM ACCESS POLICY
module "ecs_task_custom_access_policy" {
  count  = var.create_task_role && length(local.task_custom_policies) > 0 ? 1 : 0
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-iam_policy.git?ref=0.1.0"

  policy_name      = var.task_policy_name
  policy_statement = local.task_custom_policies
  tags             = local.common_tags
}

module "ecs_task_custom_access_policy_attachment" {
  count  = var.create_task_role && length(local.task_custom_policies) > 0 ? 1 : 0
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-iam_role_policy_attachment.git?ref=0.1.0"

  role_name  = module.ecs_task_role[0].role_name
  policy_arn = module.ecs_task_custom_access_policy[0].policy_arn
}

# ============================================
# ECS TASK DEFINITION
# ============================================

# Using the public tf-aws-module_primitive-ecs_task module
module "ecs_task" {
  source = "git::https://github.com/launchbynttdata/tf-aws-module_primitive-ecs_task.git?ref=0.1.0"

  # Core task configuration
  family             = var.ecs_task_family
  execution_role_arn = local.execution_role_arn_resolved
  task_role_arn      = local.task_role_arn_resolved

  # Task resource allocation
  requires_compatibilities = var.ecs_task_requires_compatibilities
  network_mode             = var.ecs_task_network_mode
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  # Container configuration
  container_definitions = [
    {
      name         = var.container_name == null ? local.ecs_container_name : var.container_name
      image        = var.container_image
      cpu          = var.container_cpu
      memory       = var.container_memory
      environment  = var.container_environment
      portMappings = var.container_port_mappings
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = local.log_group_name
          "awslogs-region"        = var.region != "" ? var.region : data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
      essential = true
    }
  ]

  # Secrets and storage
  secrets_manager_secrets = var.secrets_manager_secrets
  container_secrets       = var.container_secrets
  ephemeral_storage       = var.ephemeral_storage
  volumes                 = var.volumes

  # Runtime configuration
  ipc_mode              = var.ipc_mode
  pid_mode              = var.pid_mode
  placement_constraints = var.placement_constraints
  proxy_configuration   = var.proxy_configuration
  runtime_platform      = var.runtime_platform

  # Lifecycle management
  skip_destroy = var.skip_destroy
  track_latest = var.track_latest

  # Tags
  tags = local.common_tags
}
