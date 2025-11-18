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
| <a name="module_ecs_task"></a> [ecs\_task](#module\_ecs\_task) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_ecs_task_family"></a> [ecs\_task\_family](#input\_ecs\_task\_family) | The family name of the ECS task definition | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The name of the container | `string` | `null` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | The image to use for the container | `string` | `"nginx:latest"` | no |
| <a name="input_container_environment"></a> [container\_environment](#input\_container\_environment) | A list of environment variables to pass to the container | `list(map(string))` | `[]` | no |
| <a name="input_container_port_mappings"></a> [container\_port\_mappings](#input\_container\_port\_mappings) | A list of port mappings for the container | <pre>list(object({<br/>    containerPort = number<br/>    hostPort      = number<br/>    protocol      = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "containerPort": 80,<br/>    "hostPort": 80,<br/>    "protocol": "tcp"<br/>  }<br/>]</pre> | no |

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
