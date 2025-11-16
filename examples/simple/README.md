# Simple Example

This example provides a basic test case for the `tf-aws-module_collection-ecs_task` module, demonstrating how to create an ECS task definition with execution and task roles.

## Features

- ECS Task Definition with Fargate compatibility
- Automatic creation of execution and task IAM roles
- Container configuration with nginx image
- CloudWatch logging configuration
- Port mapping for web traffic
- Environment variables support

## Usage

```bash
terraform init
terraform plan -var-file=test.tfvars
terraform apply -var-file=test.tfvars
terraform destroy -var-file=test.tfvars
```

## Resources Created

- 1 ECS Task Definition
- 1 IAM Execution Role (if `create_execution_role` is true)
- 1 IAM Task Role (if `create_task_role` is true)
- IAM policies for the roles (if applicable)
- CloudWatch Log Group (created by the primitive ECS task module)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.100 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_task"></a> [ecs\_task](#module\_ecs\_task) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_partition"></a> [aws\_partition](#input\_aws\_partition) | AWS partition type. Used in default tags. | `string` | `"Standard"` | no |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | The number of cpu units reserved for the container | `number` | `256` | no |
| <a name="input_container_environment"></a> [container\_environment](#input\_container\_environment) | A list of environment variables to pass to the container | `list(map(string))` | `[]` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | The image to use for the container | `string` | `"nginx:latest"` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | The amount (in MiB) of memory reserved for the container | `number` | `512` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The name of the container | `string` | `null` | no |
| <a name="input_container_port_mappings"></a> [container\_port\_mappings](#input\_container\_port\_mappings) | A list of port mappings for the container | <pre>list(object({<br>    containerPort = number<br>    hostPort      = number<br>    protocol      = string<br>  }))</pre> | <pre>[<br>  {<br>    "containerPort": 80,<br>    "hostPort": 80,<br>    "protocol": "tcp"<br>  }<br>]</pre> | no |
| <a name="input_create_execution_role"></a> [create\_execution\_role](#input\_create\_execution\_role) | Whether to create the ECS task execution role | `bool` | `true` | no |
| <a name="input_create_task_role"></a> [create\_task\_role](#input\_create\_task\_role) | Whether to create the ECS task role | `bool` | `true` | no |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | The number of CPU units used by the task | `string` | `"256"` | no |
| <a name="input_ecs_task_family"></a> [ecs\_task\_family](#input\_ecs\_task\_family) | The family name of the ECS task definition | `string` | `null` | no |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | The amount (in MiB) of memory used by the task | `string` | `"512"` | no |
| <a name="input_ecs_task_network_mode"></a> [ecs\_task\_network\_mode](#input\_ecs\_task\_network\_mode) | The Docker networking mode to use for the containers in the task | `string` | `"awsvpc"` | no |
| <a name="input_ecs_task_requires_compatibilities"></a> [ecs\_task\_requires\_compatibilities](#input\_ecs\_task\_requires\_compatibilities) | The launch types required by the task (e.g., FARGATE, EC2) | `list(string)` | <pre>[<br>  "FARGATE"<br>]</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | Environment (e.g., dev, test, stg, prod, qa, poc) | `string` | `"dev"` | no |
| <a name="input_environment_type"></a> [environment\_type](#input\_environment\_type) | Environment type for the infrastructure. Used in default tags. | `string` | `"Dev"` | no |
| <a name="input_ephemeral_storage"></a> [ephemeral\_storage](#input\_ephemeral\_storage) | The amount of ephemeral storage to allocate for the task | <pre>object({<br>    size_in_gib = number<br>  })</pre> | `null` | no |
| <a name="input_execution_role_description"></a> [execution\_role\_description](#input\_execution\_role\_description) | Description for the execution role | `string` | `"ECS task execution role for pulling container images and managing logs"` | no |
| <a name="input_execution_role_name"></a> [execution\_role\_name](#input\_execution\_role\_name) | Name of the execution role to create (if create\_execution\_role is true) | `string` | `null` | no |
| <a name="input_id"></a> [id](#input\_id) | Instance/Sequential number or identifier (e.g., 01, 001, instance-1). Leave empty if not needed. | `string` | `"01"` | no |
| <a name="input_include_region_in_name"></a> [include\_region\_in\_name](#input\_include\_region\_in\_name) | Whether to include region in the resource name | `bool` | `false` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | The name of the CloudWatch log group (used in container log configuration) | `string` | `null` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization/Company abbreviation (e.g., dmvnv, salesforce, box, mulesoft, sos, gto) | `string` | `"example"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project/Application name (e.g., webapp, data-etl, mobile-api, payment-portal) | `string` | `"ecs-task"` | no |
| <a name="input_purpose"></a> [purpose](#input\_purpose) | Purpose/Function of the resource (e.g., webserver, database, frontend, backend, cache, logs, config) | `string` | `"demo"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region or availability zone (e.g., us-west-1a, eu-west-2). Optional, used for regional resources. | `string` | `"us-east-1"` | no |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | AWS resource type abbreviation (e.g., ec2, s3, vpc, rds, lambda, iam, cw, ddb, cf, r53, sns, sqs, kms, ecs, eks, ecr, alb, nlb, cfn, apigw, ebs, efs, ec, cognito, ecs\_task, ecs\_service, ecs\_container, log\_group, ecs\_task\_family) | `string` | `"ecs_task"` | no |
| <a name="input_secrets_manager_secrets"></a> [secrets\_manager\_secrets](#input\_secrets\_manager\_secrets) | Map of environment variable names to Secrets Manager secret ARNs or names | `map(string)` | `{}` | no |
| <a name="input_skip_destroy"></a> [skip\_destroy](#input\_skip\_destroy) | Whether to skip destroying the task definition | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_task_role_description"></a> [task\_role\_description](#input\_task\_role\_description) | Description for the task role | `string` | `"ECS task role for accessing AWS services from ECS tasks"` | no |
| <a name="input_task_role_name"></a> [task\_role\_name](#input\_task\_role\_name) | Name of the task role to create (if create\_task\_role is true) | `string` | `null` | no |
| <a name="input_track_latest"></a> [track\_latest](#input\_track\_latest) | Whether the ECS service should track the latest ACTIVE revision | `bool` | `false` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Configuration block for volumes | <pre>list(object({<br>    name      = string<br>    host_path = optional(string)<br>    docker_volume_configuration = optional(object({<br>      scope         = optional(string)<br>      autoprovision = optional(bool)<br>      driver        = optional(string)<br>      driver_opts   = optional(map(string))<br>      labels        = optional(map(string))<br>    }))<br>    efs_volume_configuration = optional(object({<br>      file_system_id          = string<br>      root_directory          = optional(string)<br>      transit_encryption      = optional(string)<br>      transit_encryption_port = optional(number)<br>      authorization_config = optional(object({<br>        access_point_id = optional(string)<br>        iam             = optional(string)<br>      }))<br>    }))<br>    fsx_windows_file_server_volume_configuration = optional(object({<br>      file_system_id = string<br>      root_directory = string<br>      authorization_config = object({<br>        credentials_parameter = string<br>        domain                = string<br>      })<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_definitions"></a> [container\_definitions](#output\_container\_definitions) | The container definitions in JSON format |
| <a name="output_container_names"></a> [container\_names](#output\_container\_names) | List of container names in the task definition |
| <a name="output_default_tags"></a> [default\_tags](#output\_default\_tags) | Default tags only (without module-specific or user tags) |
| <a name="output_ecs_container_name"></a> [ecs\_container\_name](#output\_ecs\_container\_name) | The fully formatted ECS container name following DMV naming convention |
| <a name="output_ecs_task_execution_role_arn"></a> [ecs\_task\_execution\_role\_arn](#output\_ecs\_task\_execution\_role\_arn) | The ARN of the created ECS task execution role (if created) |
| <a name="output_ecs_task_execution_role_name"></a> [ecs\_task\_execution\_role\_name](#output\_ecs\_task\_execution\_role\_name) | The name of the created ECS task execution role (if created) |
| <a name="output_ecs_task_family_name"></a> [ecs\_task\_family\_name](#output\_ecs\_task\_family\_name) | The fully formatted resource name following DMV naming convention |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | The ARN of the created ECS task role (if created) |
| <a name="output_ecs_task_role_name"></a> [ecs\_task\_role\_name](#output\_ecs\_task\_role\_name) | The name of the created ECS task role (if created) |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The fully formatted log group name following DMV naming convention |
| <a name="output_placement_constraints"></a> [placement\_constraints](#output\_placement\_constraints) | The placement constraints for the task |
| <a name="output_tags"></a> [tags](#output\_tags) | Merged tags with default, module-specific, and user-provided tags |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | The ARN of the ECS task definition |
| <a name="output_task_definition_arn_without_revision"></a> [task\_definition\_arn\_without\_revision](#output\_task\_definition\_arn\_without\_revision) | The ARN of the ECS task definition without revision |
| <a name="output_task_definition_cpu"></a> [task\_definition\_cpu](#output\_task\_definition\_cpu) | The number of CPU units used by the task |
| <a name="output_task_definition_family"></a> [task\_definition\_family](#output\_task\_definition\_family) | The family of the ECS task definition |
| <a name="output_task_definition_memory"></a> [task\_definition\_memory](#output\_task\_definition\_memory) | The amount of memory (in MiB) used by the task |
| <a name="output_task_definition_network_mode"></a> [task\_definition\_network\_mode](#output\_task\_definition\_network\_mode) | The Docker networking mode used by the task |
| <a name="output_task_definition_requires_compatibilities"></a> [task\_definition\_requires\_compatibilities](#output\_task\_definition\_requires\_compatibilities) | The launch types required by the task |
| <a name="output_task_definition_revision"></a> [task\_definition\_revision](#output\_task\_definition\_revision) | The revision of the ECS task definition |
| <a name="output_task_definition_tags_all"></a> [task\_definition\_tags\_all](#output\_task\_definition\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block |
| <a name="output_task_execution_role_arn"></a> [task\_execution\_role\_arn](#output\_task\_execution\_role\_arn) | The ARN of the task execution role |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The ARN of the task role |
| <a name="output_track_latest"></a> [track\_latest](#output\_track\_latest) | Whether the ECS service tracks the latest ACTIVE revision |
| <a name="output_volumes"></a> [volumes](#output\_volumes) | The volume configuration for the task |
<!-- END_TF_DOCS -->
