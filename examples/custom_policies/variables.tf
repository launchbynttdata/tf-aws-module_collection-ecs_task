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
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

# ============================================
# ECS TASK CONFIGURATION
# ============================================

variable "ecs_task_family" {
  description = "The family name of the ECS task definition"
  type        = string
}

variable "ecs_task_cpu" {
  description = "The number of CPU units used by the task"
  type        = string
  default     = "512"
}

variable "ecs_task_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = string
  default     = "1024"
}

# ============================================
# IAM CUSTOM POLICY STATEMENTS
# ============================================

variable "task_role_policy_statements" {
  description = <<-EOT
    Map of custom IAM policy statements to create as customer managed policies and attach to the ECS task role.
    When provided, replaces all auto-generated task role policy statements. Each key becomes the policy name suffix.
    Tags from var.tags are applied to each created policy automatically.
  EOT
  type = map(object({
    sid       = optional(string, "")
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
  }))
  default = null
}

# ============================================
# CONTAINER CONFIGURATION
# ============================================

variable "container_definitions" {
  description = "Map of container definitions for the ECS task. If provided, this overrides the individual container variables"
  type = map(object({
    # Fields in this object intentionally follow ECS container definition JSON names.
    # Terraform-owned module variables stay snake_case, but this object is passed
    # through as ECS JSON, so keeping AWS field names avoids breaking callers.
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
    mountPoints = optional(list(object({
      sourceVolume  = string
      containerPath = string
      readOnly      = optional(bool, false)
    })), [])
    logConfiguration = optional(object({
      logDriver = string
      options   = map(string)
    }), null)
    essential              = optional(bool, true)
    readOnlyRootFilesystem = optional(bool)
    linuxParameters = optional(object({
      capabilities = optional(object({
        add  = optional(list(string), [])
        drop = optional(list(string), [])
      }))
      devices = optional(list(object({
        containerPath = optional(string)
        hostPath      = string
        permissions   = optional(list(string), [])
      })), [])
      initProcessEnabled = optional(bool)
      maxSwap            = optional(number)
      sharedMemorySize   = optional(number)
      swappiness         = optional(number)
      tmpfs = optional(list(object({
        containerPath = string
        size          = number
        mountOptions  = optional(list(string), [])
      })), [])
    }))
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

# Individual container variables (used when container_definitions is empty)
variable "container_name" {
  description = "The name of the container"
  type        = string
  default     = null
}

variable "container_image" {
  description = "The image to use for the container"
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
    name          = optional(string)
  }))
  default = []
}

# ============================================
# RESOURCE NAME MODULE VARIABLES
# ============================================

variable "logical_product_family" {
  description = "Name of the product family for which the resource is created. Example: org_name, department_name."
  type        = string
}

variable "logical_product_service" {
  description = "Name of the product service for which the resource is created. For example, backend, frontend, middleware etc."
  type        = string
}

variable "region" {
  description = "The location where the resource will be created. Must not have spaces For example, us-east-2, useast2, West-US-2"
  type        = string
}

variable "class_env" {
  description = "Environment where resource is going to be deployed. For example. dev, qa, uat"
  type        = string
}

variable "instance_env" {
  description = "Number that represents the instance of the environment."
  type        = number
  default     = 0
}

variable "cloud_resource_type_execution" {
  description = "Abbreviation for the type of resource for execution role."
  type        = string
  default     = "executionrole"
}

variable "cloud_resource_type_task" {
  description = "Abbreviation for the type of resource for task role."
  type        = string
  default     = "taskrole"
}

variable "cloud_resource_type_policy" {
  description = "Abbreviation for the type of resource for task policy."
  type        = string
  default     = "taskpolicy"
}

variable "instance_resource" {
  description = "Number that represents the instance of the resource."
  type        = number
  default     = 0
}

variable "maximum_length" {
  description = "Number that represents the maximum length the resource name could have."
  type        = number
  default     = 60
}

variable "separator" {
  description = "Separator to be used in the name"
  type        = string
  default     = "-"
}
