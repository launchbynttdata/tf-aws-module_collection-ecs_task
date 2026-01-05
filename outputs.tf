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
# TAGS MODULE OUTPUTS
# ============================================

output "tags" {
  description = "Merged tags with default, module-specific, and user-provided tags"
  value       = var.tags
}

# ============================================
# RESOURCE NAMES MODULE OUTPUTS
# ============================================

output "ecs_task_family_name" {
  description = "The fully formatted resource name following DMV naming convention"
  value       = var.ecs_task_family
}

output "ecs_container_name" {
  description = "The fully formatted ECS container name following DMV naming convention"
  value       = local.ecs_container_name
}

output "log_group_name" {
  description = "The fully formatted log group name following DMV naming convention"
  value       = local.log_group_name
}

# ============================================
# ECS TASK OUTPUTS
# ============================================

output "task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = module.ecs_task.arn
}

output "task_definition_arn_without_revision" {
  description = "The ARN of the ECS task definition without revision"
  value       = replace(module.ecs_task.arn, ":${module.ecs_task.revision}", "")
}

output "task_definition_family" {
  description = "The family of the ECS task definition"
  value       = module.ecs_task.family
}

output "task_definition_revision" {
  description = "The revision of the ECS task definition"
  value       = module.ecs_task.revision
}

output "task_definition_network_mode" {
  description = "The Docker networking mode used by the task"
  value       = module.ecs_task.network_mode
}

output "task_definition_requires_compatibilities" {
  description = "The launch types required by the task"
  value       = module.ecs_task.requires_compatibilities
}

output "task_definition_cpu" {
  description = "The number of CPU units used by the task"
  value       = module.ecs_task.cpu
}

output "task_definition_memory" {
  description = "The amount of memory (in MiB) used by the task"
  value       = module.ecs_task.memory
}

output "task_execution_role_arn" {
  description = "The ARN of the task execution role"
  value       = local.execution_role_arn_resolved
}

output "task_role_arn" {
  description = "The ARN of the task role"
  value       = local.task_role_arn_resolved
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the created ECS task execution role (if created)"
  value       = var.create_execution_role ? module.ecs_task_execution_role[0].role_arn : null
}

output "ecs_task_execution_role_name" {
  description = "The name of the created ECS task execution role (if created)"
  value       = var.create_execution_role ? module.ecs_task_execution_role[0].role_name : null
}

output "ecs_task_execution_role_unique_id" {
  description = "The unique ID of the created ECS task execution role (if created)"
  value       = var.create_execution_role ? module.ecs_task_execution_role[0].role_unique_id : null
}

output "ecs_task_role_arn" {
  description = "The ARN of the created ECS task role (if created)"
  value       = var.create_task_role ? module.ecs_task_role[0].role_arn : null
}

output "ecs_task_role_name" {
  description = "The name of the created ECS task role (if created)"
  value       = var.create_task_role ? module.ecs_task_role[0].role_name : null
}

output "ecs_task_role_id" {
  description = "The unique ID of the created ECS task role (if created)"
  value       = var.create_task_role ? module.ecs_task_role[0].role_id : null
}

output "ecs_task_role_unique_id" {
  description = "The unique ID of the created ECS task role (if created)"
  value       = var.create_task_role ? module.ecs_task_role[0].role_unique_id : null
}

output "ecs_task_role_create_date" {
  description = "The creation date of the created ECS task role (if created)"
  value       = var.create_task_role ? module.ecs_task_role[0].create_date : null
}

output "ecs_task_role_tags" {
  description = "The tags applied to the created ECS task role (if created)"
  value       = var.create_task_role ? module.ecs_task_role[0].role_tags : null
}

output "ecs_task_role_custom_policy_arns" {
  description = "Map of custom policy names to their ARNs for the ECS task role"
  value       = var.create_task_role && length(local.task_custom_policies) > 0 ? { for k, v in module.ecs_task_role_custom_policies : k => v.policy_arn } : {}
}

output "ecs_task_role_custom_policy_names" {
  description = "Map of custom policy names to their names for the ECS task role"
  value       = var.create_task_role && length(local.task_custom_policies) > 0 ? { for k, v in module.ecs_task_role_custom_policies : k => v.policy_name } : {}
}

output "ecs_task_role_custom_policy_ids" {
  description = "Map of custom policy names to their IDs for the ECS task role"
  value       = var.create_task_role && length(local.task_custom_policies) > 0 ? { for k, v in module.ecs_task_role_custom_policies : k => v.policy_id } : {}
}

output "container_names" {
  description = "List of container names in the task definition"
  value       = [var.container_name != null ? var.container_name : local.ecs_container_name]
}

output "container_definitions" {
  description = "The container definitions in JSON format"
  value       = jsonencode(local.container_definitions)
  sensitive   = true
}

output "task_definition_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = module.ecs_task.tags_all
}

output "track_latest" {
  description = "Whether the ECS service tracks the latest ACTIVE revision"
  value       = var.track_latest
}

output "placement_constraints" {
  description = "The placement constraints for the task"
  value       = var.placement_constraints
}

output "volumes" {
  description = "The volume configuration for the task"
  value       = var.volumes
}
