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
# TAGS OUTPUTS
# ============================================

output "tags" {
  description = "Merged tags with default, module-specific, and user-provided tags"
  value       = module.ecs_task.tags
}

output "default_tags" {
  description = "Default tags only (without module-specific or user tags)"
  value       = module.ecs_task.default_tags
}

# ============================================
# RESOURCE NAMES OUTPUTS
# ============================================

output "ecs_task_family_name" {
  description = "The fully formatted resource name following DMV naming convention"
  value       = module.ecs_task.ecs_task_family_name
}

output "ecs_container_name" {
  description = "The fully formatted ECS container name following DMV naming convention"
  value       = module.ecs_task.ecs_container_name
}

output "log_group_name" {
  description = "The fully formatted log group name following DMV naming convention"
  value       = module.ecs_task.log_group_name
}

# ============================================
# ECS TASK DEFINITION OUTPUTS
# ============================================

output "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = module.ecs_task.task_definition_arn
}

output "task_definition_arn_without_revision" {
  description = "The ARN of the ECS task definition without revision"
  value       = module.ecs_task.task_definition_arn_without_revision
}

output "task_definition_family" {
  description = "The family of the ECS task definition"
  value       = module.ecs_task.task_definition_family
}

output "task_definition_revision" {
  description = "The revision of the ECS task definition"
  value       = module.ecs_task.task_definition_revision
}

output "task_definition_network_mode" {
  description = "The Docker networking mode used by the task"
  value       = module.ecs_task.task_definition_network_mode
}

output "task_definition_requires_compatibilities" {
  description = "The launch types required by the task"
  value       = module.ecs_task.task_definition_requires_compatibilities
}

output "task_definition_cpu" {
  description = "The number of CPU units used by the task"
  value       = module.ecs_task.task_definition_cpu
}

output "task_definition_memory" {
  description = "The amount of memory (in MiB) used by the task"
  value       = module.ecs_task.task_definition_memory
}

# ============================================
# IAM ROLE OUTPUTS
# ============================================

output "task_execution_role_arn" {
  description = "The ARN of the task execution role"
  value       = module.ecs_task.task_execution_role_arn
}

output "task_role_arn" {
  description = "The ARN of the task role"
  value       = module.ecs_task.task_role_arn
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the created ECS task execution role (if created)"
  value       = module.ecs_task.ecs_task_execution_role_arn
}

output "ecs_task_execution_role_name" {
  description = "The name of the created ECS task execution role (if created)"
  value       = module.ecs_task.ecs_task_execution_role_name
}

output "ecs_task_role_arn" {
  description = "The ARN of the created ECS task role (if created)"
  value       = module.ecs_task.ecs_task_role_arn
}

output "ecs_task_role_name" {
  description = "The name of the created ECS task role (if created)"
  value       = module.ecs_task.ecs_task_role_name
}

# ============================================
# CONTAINER OUTPUTS
# ============================================

output "container_names" {
  description = "List of container names in the task definition"
  value       = module.ecs_task.container_names
}

output "container_definitions" {
  description = "The container definitions in JSON format"
  value       = module.ecs_task.container_definitions
  sensitive   = true
}

# ============================================
# ADDITIONAL OUTPUTS
# ============================================

output "task_definition_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = module.ecs_task.task_definition_tags_all
}

output "track_latest" {
  description = "Whether the ECS service tracks the latest ACTIVE revision"
  value       = module.ecs_task.track_latest
}

output "placement_constraints" {
  description = "The placement constraints for the task"
  value       = module.ecs_task.placement_constraints
}

output "volumes" {
  description = "The volume configuration for the task"
  value       = module.ecs_task.volumes
}
