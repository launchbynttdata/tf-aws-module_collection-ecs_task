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

data "aws_region" "current" {}

module "ecs_task" {
  source = "../../"

  # Core variables
  tags = var.tags

  # Naming variables
  org           = "example"
  project       = "ecs-task"
  env           = "dev"
  resource_type = "ecs_task"
  purpose       = "demo"
  id            = "01"
  region        = var.region

  # ECS Task configuration
  ecs_task_family = var.ecs_task_family

  # Container configuration
  container_name = var.container_name

  container_image = var.container_image

  container_environment = var.container_environment

  container_port_mappings = var.container_port_mappings

}
