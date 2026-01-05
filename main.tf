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

resource "terraform_data" "container_validation" {
  lifecycle {
    precondition {
      condition     = length(var.container_definitions) > 0 || var.container_image != null
      error_message = "Either 'container_definitions' must be provided, or 'container_image' must be specified for the default container definition."
    }
  }
}

# ============================================
# ECS TASK EXECUTION ROLE
# ============================================

module "ecs_task_execution_role" {
  count   = var.create_execution_role ? 1 : 0
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws"
  version = "~> 0.1"

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

module "execution_role_default_policy" {
  count   = var.create_execution_role && length(local.execution_role_default_policies) > 0 ? 1 : 0
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_policy/aws"
  version = "~> 0.3"

  policy_name      = var.execution_policy_name
  policy_statement = local.execution_role_default_policies
  tags             = local.common_tags
}

# Attach secret access policy to execution role
module "execution_role_default_policy_attachement" {
  count   = var.create_execution_role && length(local.execution_role_default_policies) > 0 ? 1 : 0
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws"
  version = "~> 0.1"

  role_name  = module.ecs_task_execution_role[0].role_name
  policy_arn = module.execution_role_default_policy[0].policy_arn
}

# Attach managed access policy to execution role
module "execution_role_managed_policy_attachement" {
  count   = var.create_execution_role ? length(local.execution_role_managed_policies) : 0
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws"
  version = "~> 0.1"

  role_name  = module.ecs_task_execution_role[0].role_name
  policy_arn = local.execution_role_managed_policies[count.index]
}

# ============================================
# ECS TASK ROLE
# ============================================
module "ecs_task_role" {
  count   = var.create_task_role ? 1 : 0
  source  = "terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws"
  version = "~> 0.1"

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
module "ecs_task_role_custom_policies" {
  for_each = var.create_task_role && length(local.task_custom_policies) > 0 ? local.task_custom_policies : {}
  source   = "terraform.registry.launch.nttdata.com/module_primitive/iam_policy/aws"
  version  = "~> 0.3"

  policy_name      = var.task_policy_name != null ? "${var.task_policy_name}-${each.key}" : "${var.ecs_task_family}-task-${each.key}"
  policy_statement = { (each.key) = each.value }
  tags             = local.common_tags
}

module "ecs_task_role_custom_policies_attachment" {
  for_each = module.ecs_task_role_custom_policies
  source   = "terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws"
  version  = "~> 0.1"

  role_name  = module.ecs_task_role[0].role_name
  policy_arn = each.value.policy_arn
}

# ============================================
# ECS TASK DEFINITION
# ============================================

# Using the public tf-aws-module_primitive-ecs_task module
module "ecs_task" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/ecs_task/aws"
  version = "~> 0.1"

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
  container_definitions = local.container_definitions

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
