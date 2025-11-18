# ============================================
# LOCAL VALUES
# ============================================

locals {
  # ============================================
  # COMMON LOCALS
  # ============================================

  # Shared tags from tags module
  common_tags = var.tags

  ecs_container_name = var.ecs_container_name
  log_group_name     = var.log_group_name != null ? var.log_group_name : "/ecs/${var.ecs_task_family}"

  # ============================================
  # ROLE ARN RESOLUTION
  # ============================================

  # Determine execution role ARN - use created role if create_execution_role is true, otherwise use provided ARN
  execution_role_arn_resolved = var.create_execution_role ? module.ecs_task_execution_role[0].role_arn : var.execution_role_arn

  # Determine task role ARN - use created role if create_task_role is true, otherwise use provided ARN
  task_role_arn_resolved = var.create_task_role ? module.ecs_task_role[0].role_arn : var.task_role_arn

  # ============================================
  # ECS TASK EXECUTION ROLE POLICIES
  # ============================================

  # ECS task execution assume role policy
  ecs_task_execution_role_policy = [
    {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
      }]
    }
  ]

  # AWS managed policies to attach to execution role
  execution_managed_policies = concat(
    ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"],
    var.custom_ecs_execution_policies
  )

  # Consolidated policies map for execution role IAM primitive
  execution_custom_policies = merge(
    # Secrets Manager access policy
    length(var.secrets_manager_arns) > 0 ? {
      "SecretAccess" = {
        sid       = "SecretAccess"
        actions   = var.ecs_secrets_permissions.actions
        resources = var.secrets_manager_arns
      }
    } : {},
    # KMS decryption policy
    length(var.execution_kms_key_arns) > 0 ? {
      "KmsDecrypt" = {
        sid       = "KmsDecrypt"
        actions   = var.ecs_execution_kms_permissions.actions
        resources = var.execution_kms_key_arns
      }
    } : {},
    # EFS access policy
    length(var.execution_efs_file_system_arns) > 0 ? {
      "EfsAccess" = {
        sid       = "EfsAccess"
        actions   = var.ecs_execution_efs_permissions.actions
        resources = var.execution_efs_file_system_arns
      }
    } : {},
    # Managed policy attachment permissions
    length(local.execution_managed_policies) > 0 ? {
      "ManagedPolicyAttachment" = {
        sid       = "ManagedPolicyAttachment"
        actions   = ["iam:AttachRolePolicy"]
        resources = local.execution_managed_policies
      }
    } : {}
  )

  # ============================================
  # ECS TASK ROLE POLICIES
  # ============================================

  # AWS Managed Policies to attach to task role
  task_managed_policy_arns = concat(
    var.enable_ecs_exec ? [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ] : [],
    var.custom_task_policies
  )

  # Consolidated policies map for task role IAM primitive
  task_custom_policies = merge(
    # Always included policies
    {
      "CloudWatchLogs" = {
        sid       = "VisualEditor0"
        actions   = var.ecs_task_cloudwatch_permissions.actions
        resources = var.ecs_task_cloudwatch_permissions.resources
      }
    },
    {
      "SSMSessionManager" = {
        sid       = ""
        actions   = var.ecs_task_ssm_permissions.actions
        resources = var.ecs_task_ssm_permissions.resources
      }
    },
    {
      "AppConfig" = {
        sid       = ""
        actions   = var.ecs_task_appconfig_permissions.actions
        resources = var.ecs_task_appconfig_permissions.resources
      }
    },
    # Conditional policies
    length(var.s3_bucket_arns) > 0 ? {
      "S3Access" = {
        sid       = ""
        actions   = var.ecs_task_s3_permissions.actions
        resources = concat(var.s3_bucket_arns, [for arn in var.s3_bucket_arns : "${arn}/*"])
      }
    } : {},
    length(var.task_kms_key_arns) > 0 ? {
      "KMSDecrypt" = {
        sid       = ""
        actions   = var.ecs_task_kms_permissions.actions
        resources = var.task_kms_key_arns
      }
    } : {},
    (length(var.task_efs_file_system_arns) > 0 || length(var.efs_access_point_arns) > 0) ? {
      "EFSMount" = {
        sid       = ""
        actions   = var.ecs_task_efs_permissions.actions
        resources = concat(var.task_efs_file_system_arns, var.efs_access_point_arns)
      }
    } : {},
    length(var.ecs_efs_s3_kms_arns) > 0 ? {
      "EFSKMS" = {
        sid       = ""
        actions   = var.ecs_task_kms_permissions.actions
        resources = var.ecs_efs_s3_kms_arns
      }
    } : {},
    (length(var.s3_bucket_arns) > 0 && (length(var.task_efs_file_system_arns) > 0 || length(var.efs_access_point_arns) > 0)) ? {
      "EFSS3" = {
        sid       = ""
        actions   = var.ecs_task_efs_s3_permissions.actions
        resources = concat(var.s3_bucket_arns, [for arn in var.s3_bucket_arns : "${arn}/*"])
      }
    } : {},
    # Managed policy attachment permissions
    length(local.task_managed_policy_arns) > 0 ? {
      "ManagedPolicyAttachment" = {
        sid       = "ManagedPolicyAttachment"
        actions   = ["iam:AttachRolePolicy"]
        resources = local.task_managed_policy_arns
      }
    } : {}
  )

  # ============================================
  # CONTAINER DEFINITION
  # ============================================

  container_definition = [
    {
      name        = var.container_name == null ? local.ecs_container_name : var.container_name
      image       = var.container_image
      cpu         = var.container_cpu
      memory      = var.container_memory
      environment = var.container_environment
      portMappings = [for port in var.container_port_mappings : {
        containerPort = port.containerPort
        hostPort      = 0
        protocol      = port.protocol
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = local.log_group_name != null ? local.log_group_name : (var.log_group_name != null ? var.log_group_name : "/ecs/${var.ecs_task_family}")
          "awslogs-region"        = var.region != "" ? var.region : data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
      essential = true
    }
  ]
}
