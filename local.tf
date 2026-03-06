// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
  execution_role_managed_policies = concat(
    ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"],
    var.execution_role_custom_policies
  )

  # Consolidated policies map for execution role IAM primitive
  execution_role_default_policies = merge(
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
    } : {}
  )

  # ============================================
  # ECS TASK ROLE POLICIES
  # ============================================

  # CloudWatch permissions logic
  cloudwatch_permissions = var.ecs_task_cloudwatch_permissions != null ? var.ecs_task_cloudwatch_permissions : (var.enable_ecs_task_cloudwatch_permissions ? {
    actions   = ["logs:CreateLogGroup"]
    resources = ["*"]
  } : null)

  # SSM permissions logic
  ssm_permissions = var.ecs_task_ssm_permissions != null ? var.ecs_task_ssm_permissions : (var.enable_ecs_task_ssm_permissions ? {
    actions = [
      "ssmmessages:*",
      "ssm:UpdateInstanceInformation",
      "ssm:StartSession",
      "ssm:DescribeSessions",
      "ssm:GetConnectionStatus"
    ]
    resources = ["*"]
  } : null)

  # AppConfig permissions logic
  appconfig_permissions = var.ecs_task_appconfig_permissions != null ? var.ecs_task_appconfig_permissions : (var.enable_ecs_task_appconfig_permissions ? {
    actions = [
      "appconfig:StartConfigurationSession",
      "appconfig:GetConfiguration",
      "appconfig:GetConfigurationProfile",
      "appconfig:GetLatestConfiguration",
      "appconfig:GetApplication",
      "appconfig:GetEnvironment",
      "appconfig:ListApplications",
      "appconfig:ListConfigurationProfiles",
      "appconfig:ListEnvironments",
      "appconfig:GetDeployment",
      "appconfig:ListDeployments"
    ]
    resources = ["*"]
  } : null)

  # S3 permissions logic
  s3_permissions = var.ecs_task_s3_permissions != null ? var.ecs_task_s3_permissions : (var.enable_ecs_task_s3_permissions ? {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
      "s3:PutObjectAcl"
    ]
  } : null)

  # EFS permissions logic
  efs_permissions = var.ecs_task_efs_permissions != null ? var.ecs_task_efs_permissions : (var.enable_ecs_task_efs_permissions ? {
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess",
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems"
    ]
  } : null)

  # EFS S3 permissions logic
  efs_s3_permissions = var.ecs_task_efs_s3_permissions != null ? var.ecs_task_efs_s3_permissions : (var.enable_ecs_task_efs_s3_permissions ? {
    actions = ["s3:GetObject"]
  } : null)

  # AWS Managed Policies to attach to task role
  task_managed_policy_arns = concat(
    var.enable_ecs_exec ? [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ] : [],
    var.custom_task_policies
  )

  # Consolidated policies map for task role IAM primitive
  task_custom_policies = merge(
    # Conditional policies
    local.cloudwatch_permissions != null ? {
      "CloudWatchLogs" = {
        sid       = "VisualEditor0"
        actions   = local.cloudwatch_permissions.actions
        resources = local.cloudwatch_permissions.resources
      }
    } : {},
    local.ssm_permissions != null ? {
      "SSMSessionManager" = {
        sid       = ""
        actions   = local.ssm_permissions.actions
        resources = local.ssm_permissions.resources
      }
    } : {},
    local.appconfig_permissions != null ? {
      "AppConfig" = {
        sid       = ""
        actions   = local.appconfig_permissions.actions
        resources = local.appconfig_permissions.resources
      }
    } : {},
    length(var.s3_bucket_arns) > 0 && local.s3_permissions != null ? {
      "S3Access" = {
        sid       = ""
        actions   = local.s3_permissions.actions
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
    (length(var.task_efs_file_system_arns) > 0 || length(var.efs_access_point_arns) > 0) && local.efs_permissions != null ? {
      "EFSMount" = {
        sid       = ""
        actions   = local.efs_permissions.actions
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
    (length(var.s3_bucket_arns) > 0 && (length(var.task_efs_file_system_arns) > 0 || length(var.efs_access_point_arns) > 0)) && local.efs_s3_permissions != null ? {
      "EFSS3" = {
        sid       = ""
        actions   = local.efs_s3_permissions.actions
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
  # CONTAINER DEFINITIONS
  # ============================================

  container_definitions = length(var.container_definitions) > 0 ? values(var.container_definitions) : [
    {
      name        = var.container_name == null ? local.ecs_container_name : var.container_name
      image       = var.container_image
      cpu         = var.container_cpu
      memory      = var.container_memory
      environment = var.container_environment
      portMappings = [for port in var.container_port_mappings : {
        containerPort = port.containerPort
        hostPort      = port.hostPort
        protocol      = port.protocol
        name          = port.name
      }]
      mountPoints = []
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = local.log_group_name
          "awslogs-region"        = var.region != "" ? var.region : data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
      essential   = true
      healthCheck = null
    }
  ]
}
