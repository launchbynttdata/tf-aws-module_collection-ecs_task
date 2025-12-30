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


module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.2"

  for_each = local.resource_name_configs

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  region                  = var.region
  class_env               = var.class_env
  instance_env            = var.instance_env
  cloud_resource_type     = each.value.cloud_resource_type
  instance_resource       = var.instance_resource
  maximum_length          = var.maximum_length
  separator               = var.separator
}

module "ecs_task" {
  source = "../../"

  # Core variables
  tags = var.tags

  # ECS Task configuration
  ecs_task_family = var.ecs_task_family
  ecs_task_cpu    = var.ecs_task_cpu
  ecs_task_memory = var.ecs_task_memory

  # IAM Role configuration
  execution_role_name = module.resource_names["execution"].standard
  task_role_name      = module.resource_names["task"].standard
  task_policy_name    = module.resource_names["policy"].standard

  # Container configuration
  container_definitions = var.container_definitions

  # Required individual container variables (used as fallback when container_definitions is empty)
  container_name  = "dummy"
  container_image = "dummy:latest"

  # Enable specific permissions
  enable_ecs_task_cloudwatch_permissions = true
  enable_ecs_task_ssm_permissions        = true
  enable_ecs_task_appconfig_permissions  = false
  enable_ecs_task_s3_permissions         = false

}
