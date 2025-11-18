# tf-aws-module_collection-ecs_task

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_family"></a> [family](#input\_family) | The family name of the ECS task definition | `string` | n/a | yes |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | The ARN of the task execution role that containers can assume | `string` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | The ARN of the IAM role that containers in this task can assume | `string` | n/a | yes |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions as a list of objects or JSON string. Will be automatically converted to JSON format. | `any` | n/a | yes |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | The launch types required by the task (e.g., FARGATE, EC2) | `list(string)` | `["FARGATE"]` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | The Docker networking mode to use for the containers in the task | `string` | `"awsvpc"` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The number of CPU units used by the task | `string` | `"256"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount (in MiB) of memory used by the task | `string` | `"512"` | no |
| <a name="input_secrets_manager_secrets"></a> [secrets\_manager\_secrets](#input\_secrets\_manager\_secrets) | Map of environment variable names to Secrets Manager secret ARNs or names | `map(string)` | `{}` | no |
| <a name="input_container_secrets"></a> [container\_secrets](#input\_container\_secrets) | List of secrets to pass to container (legacy format) | <pre>list(object({<br/>    name      = string<br/>    valueFrom = string<br/>  }))</pre> | `[]` | no |
| <a name="input_ephemeral_storage"></a> [ephemeral\_storage](#input\_ephemeral\_storage) | The amount of ephemeral storage to allocate for the task | <pre>object({<br/>    size_in_gib = number<br/>  })</pre> | `null` | no |
| <a name="input_ipc_mode"></a> [ipc\_mode](#input\_ipc\_mode) | The IPC resource namespace to be used for the containers in the task | `string` | `null` | no |
| <a name="input_pid_mode"></a> [pid\_mode](#input\_pid\_mode) | The process namespace to use for the containers in the task | `string` | `null` | no |
| <a name="input_skip_destroy"></a> [skip\_destroy](#input\_skip\_destroy) | Whether to skip destroying the task definition | `bool` | `false` | no |
| <a name="input_track_latest"></a> [track\_latest](#input\_track\_latest) | Whether the ECS service should track the latest ACTIVE revision | `bool` | `false` | no |
| <a name="input_placement_constraints"></a> [placement\_constraints](#input\_placement\_constraints) | Configuration block for placement constraints | <pre>list(object({<br/>    type       = string<br/>    expression = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_proxy_configuration"></a> [proxy\_configuration](#input\_proxy\_configuration) | Configuration block for the proxy configuration | <pre>object({<br/>    type           = string<br/>    container_name = string<br/>    properties     = optional(map(string), {})<br/>  })</pre> | `null` | no |
| <a name="input_runtime_platform"></a> [runtime\_platform](#input\_runtime\_platform) | Configuration block for runtime platform | <pre>object({<br/>    operating_system_family = optional(string)<br/>    cpu_architecture        = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Configuration block for volumes | <pre>list(object({<br/>    name      = string<br/>    host_path = optional(string)<br/>    docker_volume_configuration = optional(object({<br/>      scope         = optional(string)<br/>      autoprovision = optional(bool)<br/>      driver        = optional(string)<br/>      driver_opts   = optional(map(string))<br/>      labels        = optional(map(string))<br/>    }))<br/>    efs_volume_configuration = optional(object({<br/>      file_system_id          = string<br/>      root_directory          = optional(string)<br/>      transit_encryption      = optional(string)<br/>      transit_encryption_port = optional(number)<br/>      authorization_config = optional(object({<br/>        access_point_id = optional(string)<br/>        iam             = optional(string)<br/>      }))<br/>    }))<br/>    fsx_windows_file_server_volume_configuration = optional(object({<br/>      file_system_id = string<br/>      root_directory = string<br/>      authorization_config = object({<br/>        credentials_parameter = string<br/>        domain                = string<br/>      })<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the ECS task definition |
| <a name="output_arn_without_revision"></a> [arn\_without\_revision](#output\_arn\_without\_revision) | The ARN of the ECS task definition without revision |
| <a name="output_family"></a> [family](#output\_family) | The family of the ECS task definition |
| <a name="output_revision"></a> [revision](#output\_revision) | The revision of the ECS task definition |
| <a name="output_network_mode"></a> [network\_mode](#output\_network\_mode) | The Docker networking mode used by the task |
| <a name="output_requires_compatibilities"></a> [requires\_compatibilities](#output\_requires\_compatibilities) | The launch types required by the task |
| <a name="output_cpu"></a> [cpu](#output\_cpu) | The number of CPU units used by the task |
| <a name="output_memory"></a> [memory](#output\_memory) | The amount of memory (in MiB) used by the task |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | The ARN of the task execution role |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The ARN of the task role |
| <a name="output_container_names"></a> [container\_names](#output\_container\_names) | List of container names in the task definition |
| <a name="output_container_definitions"></a> [container\_definitions](#output\_container\_definitions) | The container definitions in JSON format |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block |
| <a name="output_track_latest"></a> [track\_latest](#output\_track\_latest) | Whether the ECS service tracks the latest ACTIVE revision |
| <a name="output_placement_constraints"></a> [placement\_constraints](#output\_placement\_constraints) | The placement constraints for the task |
| <a name="output_volumes"></a> [volumes](#output\_volumes) | The volume configuration for the task |
<!-- END_TF_DOCS -->
