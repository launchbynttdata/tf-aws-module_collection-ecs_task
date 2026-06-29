# simple

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
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.2 |
| <a name="module_ecs_task"></a> [ecs\_task](#module\_ecs\_task) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_ecs_task_family"></a> [ecs\_task\_family](#input\_ecs\_task\_family) | The family name of the ECS task definition | `string` | n/a | yes |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | The number of CPU units used by the task | `string` | `"512"` | no |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | The amount (in MiB) of memory used by the task | `string` | `"1024"` | no |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Map of container definitions for the ECS task. If provided, this overrides the individual container variables | <pre>map(object({<br/>    # Fields in this object intentionally follow ECS container definition JSON names.<br/>    # Terraform-owned module variables stay snake_case, but this object is passed<br/>    # through as ECS JSON, so keeping AWS field names avoids breaking callers.<br/>    name        = string<br/>    image       = string<br/>    cpu         = optional(number, 256)<br/>    memory      = optional(number, 512)<br/>    environment = optional(list(map(string)), [])<br/>    portMappings = optional(list(object({<br/>      containerPort = number<br/>      hostPort      = optional(number)<br/>      protocol      = optional(string, "tcp")<br/>    })), [])<br/>    mountPoints = optional(list(object({<br/>      sourceVolume  = string<br/>      containerPath = string<br/>      readOnly      = optional(bool, false)<br/>    })), [])<br/>    logConfiguration = optional(object({<br/>      logDriver = string<br/>      options   = map(string)<br/>    }), null)<br/>    essential              = optional(bool, true)<br/>    readOnlyRootFilesystem = optional(bool)<br/>    linuxParameters = optional(object({<br/>      capabilities = optional(object({<br/>        add  = optional(list(string), [])<br/>        drop = optional(list(string), [])<br/>      }))<br/>      devices = optional(list(object({<br/>        containerPath = optional(string)<br/>        hostPath      = string<br/>        permissions   = optional(list(string), [])<br/>      })), [])<br/>      initProcessEnabled = optional(bool)<br/>      maxSwap            = optional(number)<br/>      sharedMemorySize   = optional(number)<br/>      swappiness         = optional(number)<br/>      tmpfs = optional(list(object({<br/>        containerPath = string<br/>        size          = number<br/>        mountOptions  = optional(list(string), [])<br/>      })), [])<br/>    }))<br/>    healthCheck = optional(object({<br/>      command     = list(string)<br/>      interval    = number<br/>      timeout     = number<br/>      retries     = number<br/>      startPeriod = number<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Configuration block for volumes | <pre>list(object({<br/>    name      = string<br/>    host_path = optional(string)<br/>    docker_volume_configuration = optional(object({<br/>      scope         = optional(string)<br/>      autoprovision = optional(bool)<br/>      driver        = optional(string)<br/>      driver_opts   = optional(map(string))<br/>      labels        = optional(map(string))<br/>    }))<br/>    efs_volume_configuration = optional(object({<br/>      file_system_id          = string<br/>      root_directory          = optional(string)<br/>      transit_encryption      = optional(string)<br/>      transit_encryption_port = optional(number)<br/>      authorization_config = optional(object({<br/>        access_point_id = optional(string)<br/>        iam             = optional(string)<br/>      }))<br/>    }))<br/>    fsx_windows_file_server_volume_configuration = optional(object({<br/>      file_system_id = string<br/>      root_directory = string<br/>      authorization_config = object({<br/>        credentials_parameter = string<br/>        domain                = string<br/>      })<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The name of the container | `string` | `null` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | The image to use for the container | `string` | `null` | no |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | The number of cpu units reserved for the container | `number` | `256` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | The amount (in MiB) of memory reserved for the container | `number` | `512` | no |
| <a name="input_container_environment"></a> [container\_environment](#input\_container\_environment) | A list of environment variables to pass to the container | `list(map(string))` | `[]` | no |
| <a name="input_container_port_mappings"></a> [container\_port\_mappings](#input\_container\_port\_mappings) | A list of port mappings for the container | <pre>list(object({<br/>    containerPort = number<br/>    hostPort      = number<br/>    protocol      = string<br/>    name          = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Name of the product family for which the resource is created. Example: org\_name, department\_name. | `string` | n/a | yes |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Name of the product service for which the resource is created. For example, backend, frontend, middleware etc. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The location where the resource will be created. Must not have spaces For example, us-east-2, useast2, West-US-2 | `string` | n/a | yes |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | n/a | yes |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_cloud_resource_type_execution"></a> [cloud\_resource\_type\_execution](#input\_cloud\_resource\_type\_execution) | Abbreviation for the type of resource for execution role. | `string` | `"executionrole"` | no |
| <a name="input_cloud_resource_type_task"></a> [cloud\_resource\_type\_task](#input\_cloud\_resource\_type\_task) | Abbreviation for the type of resource for task role. | `string` | `"taskrole"` | no |
| <a name="input_cloud_resource_type_policy"></a> [cloud\_resource\_type\_policy](#input\_cloud\_resource\_type\_policy) | Abbreviation for the type of resource for task policy. | `string` | `"taskpolicy"` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_maximum_length"></a> [maximum\_length](#input\_maximum\_length) | Number that represents the maximum length the resource name could have. | `number` | `60` | no |
| <a name="input_separator"></a> [separator](#input\_separator) | Separator to be used in the name | `string` | `"-"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | Merged tags with default, module-specific, and user-provided tags |
| <a name="output_ecs_task_family_name"></a> [ecs\_task\_family\_name](#output\_ecs\_task\_family\_name) | The fully formatted resource name following DMV naming convention |
| <a name="output_ecs_container_name"></a> [ecs\_container\_name](#output\_ecs\_container\_name) | The fully formatted ECS container name following DMV naming convention |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The fully formatted log group name following DMV naming convention |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | The ARN of the ECS task definition |
| <a name="output_task_definition_arn_without_revision"></a> [task\_definition\_arn\_without\_revision](#output\_task\_definition\_arn\_without\_revision) | The ARN of the ECS task definition without revision |
| <a name="output_task_definition_family"></a> [task\_definition\_family](#output\_task\_definition\_family) | The family of the ECS task definition |
| <a name="output_task_definition_revision"></a> [task\_definition\_revision](#output\_task\_definition\_revision) | The revision of the ECS task definition |
| <a name="output_task_definition_network_mode"></a> [task\_definition\_network\_mode](#output\_task\_definition\_network\_mode) | The Docker networking mode used by the task |
| <a name="output_task_definition_requires_compatibilities"></a> [task\_definition\_requires\_compatibilities](#output\_task\_definition\_requires\_compatibilities) | The launch types required by the task |
| <a name="output_task_definition_cpu"></a> [task\_definition\_cpu](#output\_task\_definition\_cpu) | The number of CPU units used by the task |
| <a name="output_task_definition_memory"></a> [task\_definition\_memory](#output\_task\_definition\_memory) | The amount of memory (in MiB) used by the task |
| <a name="output_task_execution_role_arn"></a> [task\_execution\_role\_arn](#output\_task\_execution\_role\_arn) | The ARN of the task execution role |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The ARN of the task role |
| <a name="output_ecs_task_execution_role_arn"></a> [ecs\_task\_execution\_role\_arn](#output\_ecs\_task\_execution\_role\_arn) | The ARN of the created ECS task execution role (if created) |
| <a name="output_ecs_task_execution_role_name"></a> [ecs\_task\_execution\_role\_name](#output\_ecs\_task\_execution\_role\_name) | The name of the created ECS task execution role (if created) |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | The ARN of the created ECS task role (if created) |
| <a name="output_ecs_task_role_name"></a> [ecs\_task\_role\_name](#output\_ecs\_task\_role\_name) | The name of the created ECS task role (if created) |
| <a name="output_container_names"></a> [container\_names](#output\_container\_names) | List of container names in the task definition |
| <a name="output_container_definitions"></a> [container\_definitions](#output\_container\_definitions) | The container definitions in JSON format |
| <a name="output_task_definition_tags_all"></a> [task\_definition\_tags\_all](#output\_task\_definition\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block |
| <a name="output_track_latest"></a> [track\_latest](#output\_track\_latest) | Whether the ECS service tracks the latest ACTIVE revision |
| <a name="output_placement_constraints"></a> [placement\_constraints](#output\_placement\_constraints) | The placement constraints for the task |
| <a name="output_volumes"></a> [volumes](#output\_volumes) | The volume configuration for the task |
<!-- END_TF_DOCS -->
