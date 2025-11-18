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

# ============================================
# CONTAINER CONFIGURATION
# ============================================

variable "container_name" {
  description = "The name of the container"
  type        = string
  default     = null
}

variable "container_image" {
  description = "The image to use for the container"
  type        = string
  default     = "nginx:latest"
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
  default = [{
    containerPort = 80
    hostPort      = 80
    protocol      = "tcp"
  }]
}


