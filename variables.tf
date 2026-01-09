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
# CORE VARIABLES
# ============================================

variable "tags" {
  description = "A map of tags to assign to all resources created by this module."
  type        = map(string)
  default     = {}
}


# ============================================
# RESOURCE NAMES (INSTEAD OF RESOURCE_NAMES MODULE)
# ============================================

variable "ecs_container_name" {
  description = "Name for the ECS container"
  type        = string
  default     = null
}

variable "log_group_name" {
  description = "Name for the CloudWatch log group"
  type        = string
  default     = null
}

# ============================================
# ECS TASK CONFIGURATION
# ============================================

variable "ecs_task_family" {
  description = "The family name of the ECS task definition"
  type        = string
}

variable "ecs_task_requires_compatibilities" {
  description = "The launch types required by the task (e.g., FARGATE, EC2)"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "ecs_task_network_mode" {
  description = "The Docker networking mode to use for the containers in the task"
  type        = string
  default     = "awsvpc"
}

variable "ecs_task_cpu" {
  description = "The number of CPU units used by the task"
  type        = string
  default     = "256"
}

variable "ecs_task_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = string
  default     = "512"
}

variable "execution_role_arn" {
  description = "The ARN of the task execution role that containers can assume"
  type        = string
  default     = null
}

variable "task_role_arn" {
  description = "The ARN of the IAM role that containers in this task can assume"
  type        = string
  default     = null
}

# ============================================
# IAM ROLE CREATION VARIABLES
# ============================================

variable "create_execution_role" {
  description = "Whether to create the ECS task execution role"
  type        = bool
  default     = true
}

variable "create_task_role" {
  description = "Whether to create the ECS task role"
  type        = bool
  default     = true
}

variable "execution_role_name" {
  description = "Name of the execution role to create (if create_execution_role is true)"
  type        = string
  default     = null
}

variable "task_role_name" {
  description = "Name of the task role to create (if create_task_role is true)"
  type        = string
  default     = null
}

variable "execution_role_description" {
  description = "Description for the execution role"
  type        = string
  default     = "ECS task execution role for pulling container images and managing logs"
}

variable "task_role_description" {
  description = "Description for the task role"
  type        = string
  default     = "ECS task role for accessing AWS services from ECS tasks"
}

variable "secrets_manager_arns" {
  description = "List of Secrets Manager ARNs that the execution role should have access to"
  type        = list(string)
  default     = []
}

variable "execution_kms_key_arns" {
  description = "List of KMS key ARNs that the execution role should have decrypt access to"
  type        = list(string)
  default     = []
}

variable "execution_efs_file_system_arns" {
  description = "List of EFS file system ARNs that the execution role should have access to"
  type        = list(string)
  default     = []
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs that the task role should have access to"
  type        = list(string)
  default     = []
}

variable "task_kms_key_arns" {
  description = "List of KMS key ARNs that the task role should have decrypt access to"
  type        = list(string)
  default     = []
}

variable "task_efs_file_system_arns" {
  description = "List of EFS file system ARNs that the task role should have access to"
  type        = list(string)
  default     = []
}

variable "efs_access_point_arns" {
  description = "List of EFS access point ARNs that the task role should have access to"
  type        = list(string)
  default     = []
}

variable "enable_ecs_exec" {
  description = "Whether to enable ECS Exec for the task"
  type        = bool
  default     = false
}

variable "custom_task_policies" {
  description = "List of custom managed policy ARNs to attach to the task role"
  type        = list(string)
  default     = []
}

variable "container_name" {
  description = "The name of the container"
  type        = string
  default     = null
}

variable "container_image" {
  description = "The image to use for the container. This is only required if container_definitions is not provided."
  type        = string
  default     = null
}

variable "container_cpu" {
  description = "The number of cpu units reserved for the container"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory reserved for the container"
  type        = number
  default     = 512
}

variable "container_environment" {
  description = "A list of environment variables to pass to the container"
  type        = list(map(string))
  default     = []
}

variable "container_port_mappings" {
  description = "A list of port mappings for the container"
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))
  default = []
}

variable "container_definitions" {
  description = "Map of container definitions for the ECS task. If provided, this overrides the individual container variables (container_name, container_image, etc.)"
  type = map(object({
    name        = string
    image       = string
    cpu         = optional(number, 256)
    memory      = optional(number, 512)
    environment = optional(list(map(string)), [])
    portMappings = optional(list(object({
      containerPort = number
      hostPort      = optional(number)
      protocol      = optional(string, "tcp")
    })), [])
    logConfiguration = optional(object({
      logDriver = string
      options   = map(string)
    }), null)
    essential = optional(bool, true)
    healthCheck = optional(object({
      command     = list(string)
      interval    = number
      timeout     = number
      retries     = number
      startPeriod = number
    }), null)
  }))
  default = {}
}

# ============================================
# ADDITIONAL ECS TASK VARIABLES (PRIMITIVE MODULE)
# ============================================

variable "secrets_manager_secrets" {
  description = "Map of environment variable names to Secrets Manager secret ARNs or names"
  type        = map(string)
  default     = {}
}

variable "container_secrets" {
  description = "List of secrets to pass to container (legacy format)"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "ephemeral_storage" {
  description = "The amount of ephemeral storage to allocate for the task"
  type = object({
    size_in_gib = number
  })
  default = null
}

variable "ipc_mode" {
  description = "The IPC resource namespace to be used for the containers in the task"
  type        = string
  default     = null
}

variable "pid_mode" {
  description = "The process namespace to use for the containers in the task"
  type        = string
  default     = null
}

variable "skip_destroy" {
  description = "Whether to skip destroying the task definition"
  type        = bool
  default     = false
}

variable "track_latest" {
  description = "Whether the ECS service should track the latest ACTIVE revision"
  type        = bool
  default     = false
}

variable "placement_constraints" {
  description = "Configuration block for placement constraints"
  type = list(object({
    type       = string
    expression = optional(string)
  }))
  default = []
}

variable "proxy_configuration" {
  description = "Configuration block for the proxy configuration"
  type = object({
    type           = string
    container_name = string
    properties     = optional(map(string), {})
  })
  default = null
}

variable "runtime_platform" {
  description = "Configuration block for runtime platform"
  type = object({
    operating_system_family = optional(string)
    cpu_architecture        = optional(string)
  })
  default = null
}

variable "volumes" {
  description = "Configuration block for volumes"
  type = list(object({
    name      = string
    host_path = optional(string)
    docker_volume_configuration = optional(object({
      scope         = optional(string)
      autoprovision = optional(bool)
      driver        = optional(string)
      driver_opts   = optional(map(string))
      labels        = optional(map(string))
    }))
    efs_volume_configuration = optional(object({
      file_system_id          = string
      root_directory          = optional(string)
      transit_encryption      = optional(string)
      transit_encryption_port = optional(number)
      authorization_config = optional(object({
        access_point_id = optional(string)
        iam             = optional(string)
      }))
    }))
    fsx_windows_file_server_volume_configuration = optional(object({
      file_system_id = string
      root_directory = string
      authorization_config = object({
        credentials_parameter = string
        domain                = string
      })
    }))
  }))
  default = []
}

variable "path" {
  description = "The path for the IAM role."
  type        = string
  default     = null
}

# ============================================
# IAM POLICY VARIABLES
# ============================================
variable "ecs_secrets_permissions" {
  description = "Permissions for accessing secrets in ECS tasks"
  type = object({
    actions = optional(list(string), [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ])
  })
  default = {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
  }
}

variable "ecs_execution_kms_permissions" {
  description = "KMS permissions for ECS task execution role"
  type = object({
    actions = optional(list(string), [
      "kms:Decrypt",
      "kms:DescribeKey"
    ])
  })
  default = {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
  }
}

variable "ecs_execution_efs_permissions" {
  description = "EFS permissions for ECS task execution role"
  type = object({
    actions = optional(list(string), [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRead",
      "elasticfilesystem:ClientRootAccess"
    ])
  })
  default = {
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRead",
      "elasticfilesystem:ClientRootAccess"
    ]
  }
}

variable "execution_policy_name" {
  description = "The name of the IAM policy."
  type        = string
  default     = null
}

variable "task_policy_name" {
  description = "The name of the IAM policy for the task role."
  type        = string
  default     = null
}

variable "execution_role_custom_policies" {
  description = "List of custom policy ARNs to attach to ECS task execution role"
  type        = list(string)
  default     = []
}

variable "ecs_efs_s3_kms_arns" {
  description = <<-EOT
List of KMS key ARNs used by the containerized app to decrypt data.
ARN of KMS key used by the containerized app to decrypt data you explicitly encrypted with KMS for the files stored in EFS volume; ARN of the KMS key used by ECS task to read files from S3 buckets that are encrypted with SSE‑KMS; ARN of KMS key used for any client‑side encryption where the container performs decryption.
EOT
  type        = list(string)
  default     = []
}

variable "ecs_task_kms_permissions" {
  description = "KMS permissions for ECS task role"
  type = object({
    actions = optional(list(string), [
      "kms:Decrypt",
      "kms:DescribeKey"
    ])
  })
  default = {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
  }
}
variable "region" {
  description = "AWS region or availability zone (e.g., us-west-1a, eu-west-2). Optional, used for regional resources."
  type        = string
  default     = ""

  validation {
    condition     = var.region == "" || can(regex("^[a-z0-9_-]+$", var.region))
    error_message = "Region must contain only lowercase alphanumeric characters, underscores and hyphens."
  }
}

# ============================================
# ECS TASK ROLE POLICY CUSTOMIZATION
# ============================================

variable "ecs_task_cloudwatch_permissions" {
  description = "CloudWatch Logs permissions for ECS task role"
  type = object({
    actions   = optional(list(string), ["logs:CreateLogGroup"])
    resources = optional(list(string), ["*"])
  })
  default = null
}

variable "enable_ecs_task_cloudwatch_permissions" {
  description = "Whether to enable CloudWatch Logs permissions for ECS task role when not explicitly provided"
  type        = bool
  default     = false
}

variable "ecs_task_ssm_permissions" {
  description = "SSM Session Manager permissions for ECS task role"
  type = object({
    actions = optional(list(string), [
      "ssmmessages:*",
      "ssm:UpdateInstanceInformation",
      "ssm:StartSession",
      "ssm:DescribeSessions",
      "ssm:GetConnectionStatus"
    ])
    resources = optional(list(string), ["*"])
  })
  default = null
}

variable "enable_ecs_task_ssm_permissions" {
  description = "Whether to enable SSM Session Manager permissions for ECS task role when not explicitly provided"
  type        = bool
  default     = false
}

variable "ecs_task_appconfig_permissions" {
  description = "AppConfig permissions for ECS task role"
  type = object({
    actions = optional(list(string), [
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
    ])
    resources = optional(list(string), ["*"])
  })
  default = null
}

variable "enable_ecs_task_appconfig_permissions" {
  description = "Whether to enable AppConfig permissions for ECS task role when not explicitly provided"
  type        = bool
  default     = false
}

variable "ecs_task_s3_permissions" {
  description = "S3 permissions for ECS task role"
  type = object({
    actions = optional(list(string), [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
      "s3:PutObjectAcl"
    ])
  })
  default = null
}

variable "enable_ecs_task_s3_permissions" {
  description = "Whether to enable S3 permissions for ECS task role when not explicitly provided"
  type        = bool
  default     = false
}

variable "ecs_task_efs_permissions" {
  description = "EFS permissions for ECS task role"
  type = object({
    actions = optional(list(string), [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess",
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems"
    ])
  })
  default = null
}

variable "enable_ecs_task_efs_permissions" {
  description = "Whether to enable EFS permissions for ECS task role when not explicitly provided"
  type        = bool
  default     = false
}

variable "ecs_task_efs_s3_permissions" {
  description = "S3 permissions for EFS integration with ECS task role"
  type = object({
    actions = optional(list(string), ["s3:GetObject"])
  })
  default = null
}

variable "enable_ecs_task_efs_s3_permissions" {
  description = "Whether to enable S3 permissions for EFS integration with ECS task role when not explicitly provided"
  type        = bool
  default     = false
}
