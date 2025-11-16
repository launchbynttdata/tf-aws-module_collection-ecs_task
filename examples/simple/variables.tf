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
# NAMING MODULE VARIABLES
# ============================================

variable "org" {
  description = "Organization/Company abbreviation (e.g., dmvnv, salesforce, box, mulesoft, sos, gto)"
  type        = string
  default     = "example"
}

variable "project" {
  description = "Project/Application name (e.g., webapp, data-etl, mobile-api, payment-portal)"
  type        = string
  default     = "ecs-task"
}

variable "env" {
  description = "Environment (e.g., dev, test, stg, prod, qa, poc)"
  type        = string
  default     = "dev"
}

variable "purpose" {
  description = "Purpose/Function of the resource (e.g., webserver, database, frontend, backend, cache, logs, config)"
  type        = string
  default     = "demo"
}

variable "resource_type" {
  description = "AWS resource type abbreviation (e.g., ec2, s3, vpc, rds, lambda, iam, cw, ddb, cf, r53, sns, sqs, kms, ecs, eks, ecr, alb, nlb, cfn, apigw, ebs, efs, ec, cognito, ecs_task, ecs_service, ecs_container, log_group, ecs_task_family)"
  type        = string
  default     = "ecs_task"
}

variable "id" {
  description = "Instance/Sequential number or identifier (e.g., 01, 001, instance-1). Leave empty if not needed."
  type        = string
  default     = "01"
}

variable "region" {
  description = "AWS region or availability zone (e.g., us-west-1a, eu-west-2). Optional, used for regional resources."
  type        = string
  default     = "us-east-1"
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


