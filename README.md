# tf-aws-module_collection-ecs_task

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.100 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_task_execution_role"></a> [ecs\_task\_execution\_role](#module\_ecs\_task\_execution\_role) | terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws | ~> 0.1 |
| <a name="module_execution_role_default_policy"></a> [execution\_role\_default\_policy](#module\_execution\_role\_default\_policy) | terraform.registry.launch.nttdata.com/module_primitive/iam_policy/aws | ~> 0.3 |
| <a name="module_execution_role_default_policy_attachement"></a> [execution\_role\_default\_policy\_attachement](#module\_execution\_role\_default\_policy\_attachement) | terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws | ~> 0.1 |
| <a name="module_execution_role_managed_policy_attachement"></a> [execution\_role\_managed\_policy\_attachement](#module\_execution\_role\_managed\_policy\_attachement) | terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws | ~> 0.1 |
| <a name="module_ecs_task_role"></a> [ecs\_task\_role](#module\_ecs\_task\_role) | terraform.registry.launch.nttdata.com/module_primitive/iam_role/aws | ~> 0.1 |
| <a name="module_ecs_task_role_custom_policies"></a> [ecs\_task\_role\_custom\_policies](#module\_ecs\_task\_role\_custom\_policies) | terraform.registry.launch.nttdata.com/module_primitive/iam_policy/aws | ~> 0.3 |
| <a name="module_ecs_task_role_custom_policies_attachment"></a> [ecs\_task\_role\_custom\_policies\_attachment](#module\_ecs\_task\_role\_custom\_policies\_attachment) | terraform.registry.launch.nttdata.com/module_primitive/iam_role_policy_attachment/aws | ~> 0.1 |
| <a name="module_ecs_task"></a> [ecs\_task](#module\_ecs\_task) | terraform.registry.launch.nttdata.com/module_primitive/ecs_task/aws | ~> 0.1 |

## Resources

| Name | Type |
|------|------|
| [terraform_data.role_validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_ecs_container_name"></a> [ecs\_container\_name](#input\_ecs\_container\_name) | Name for the ECS container | `string` | `null` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | Name for the CloudWatch log group | `string` | `null` | no |
| <a name="input_ecs_task_family"></a> [ecs\_task\_family](#input\_ecs\_task\_family) | The family name of the ECS task definition | `string` | n/a | yes |
| <a name="input_ecs_task_requires_compatibilities"></a> [ecs\_task\_requires\_compatibilities](#input\_ecs\_task\_requires\_compatibilities) | The launch types required by the task (e.g., FARGATE, EC2) | `list(string)` | <pre>[<br/>  "FARGATE"<br/>]</pre> | no |
| <a name="input_ecs_task_network_mode"></a> [ecs\_task\_network\_mode](#input\_ecs\_task\_network\_mode) | The Docker networking mode to use for the containers in the task | `string` | `"awsvpc"` | no |
| <a name="input_ecs_task_cpu"></a> [ecs\_task\_cpu](#input\_ecs\_task\_cpu) | The number of CPU units used by the task | `string` | `"256"` | no |
| <a name="input_ecs_task_memory"></a> [ecs\_task\_memory](#input\_ecs\_task\_memory) | The amount (in MiB) of memory used by the task | `string` | `"512"` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | The ARN of the task execution role that containers can assume | `string` | `null` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | The ARN of the IAM role that containers in this task can assume | `string` | `null` | no |
| <a name="input_create_execution_role"></a> [create\_execution\_role](#input\_create\_execution\_role) | Whether to create the ECS task execution role | `bool` | `true` | no |
| <a name="input_create_task_role"></a> [create\_task\_role](#input\_create\_task\_role) | Whether to create the ECS task role | `bool` | `true` | no |
| <a name="input_execution_role_name"></a> [execution\_role\_name](#input\_execution\_role\_name) | Name of the execution role to create (if create\_execution\_role is true) | `string` | `null` | no |
| <a name="input_task_role_name"></a> [task\_role\_name](#input\_task\_role\_name) | Name of the task role to create (if create\_task\_role is true) | `string` | `null` | no |
| <a name="input_execution_role_description"></a> [execution\_role\_description](#input\_execution\_role\_description) | Description for the execution role | `string` | `"ECS task execution role for pulling container images and managing logs"` | no |
| <a name="input_task_role_description"></a> [task\_role\_description](#input\_task\_role\_description) | Description for the task role | `string` | `"ECS task role for accessing AWS services from ECS tasks"` | no |
| <a name="input_secrets_manager_arns"></a> [secrets\_manager\_arns](#input\_secrets\_manager\_arns) | List of Secrets Manager ARNs that the execution role should have access to | `list(string)` | `[]` | no |
| <a name="input_execution_kms_key_arns"></a> [execution\_kms\_key\_arns](#input\_execution\_kms\_key\_arns) | List of KMS key ARNs that the execution role should have decrypt access to | `list(string)` | `[]` | no |
| <a name="input_execution_efs_file_system_arns"></a> [execution\_efs\_file\_system\_arns](#input\_execution\_efs\_file\_system\_arns) | List of EFS file system ARNs that the execution role should have access to | `list(string)` | `[]` | no |
| <a name="input_s3_bucket_arns"></a> [s3\_bucket\_arns](#input\_s3\_bucket\_arns) | List of S3 bucket ARNs that the task role should have access to | `list(string)` | `[]` | no |
| <a name="input_task_kms_key_arns"></a> [task\_kms\_key\_arns](#input\_task\_kms\_key\_arns) | List of KMS key ARNs that the task role should have decrypt access to | `list(string)` | `[]` | no |
| <a name="input_task_efs_file_system_arns"></a> [task\_efs\_file\_system\_arns](#input\_task\_efs\_file\_system\_arns) | List of EFS file system ARNs that the task role should have access to | `list(string)` | `[]` | no |
| <a name="input_efs_access_point_arns"></a> [efs\_access\_point\_arns](#input\_efs\_access\_point\_arns) | List of EFS access point ARNs that the task role should have access to | `list(string)` | `[]` | no |
| <a name="input_enable_ecs_exec"></a> [enable\_ecs\_exec](#input\_enable\_ecs\_exec) | Whether to enable ECS Exec for the task | `bool` | `false` | no |
| <a name="input_custom_task_policies"></a> [custom\_task\_policies](#input\_custom\_task\_policies) | List of custom managed policy ARNs to attach to the task role | `list(string)` | `[]` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The name of the container | `string` | `null` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | The image to use for the container | `string` | n/a | yes |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | The number of cpu units reserved for the container | `number` | `256` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | The amount (in MiB) of memory reserved for the container | `number` | `512` | no |
| <a name="input_container_environment"></a> [container\_environment](#input\_container\_environment) | A list of environment variables to pass to the container | `list(map(string))` | `[]` | no |
| <a name="input_container_port_mappings"></a> [container\_port\_mappings](#input\_container\_port\_mappings) | A list of port mappings for the container | <pre>list(object({<br/>    containerPort = number<br/>    hostPort      = number<br/>    protocol      = string<br/>  }))</pre> | `[]` | no |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Map of container definitions for the ECS task. If provided, this overrides the individual container variables (container\_name, container\_image, etc.) | <pre>map(object({<br/>    name        = string<br/>    image       = string<br/>    cpu         = optional(number, 256)<br/>    memory      = optional(number, 512)<br/>    environment = optional(list(map(string)), [])<br/>    portMappings = optional(list(object({<br/>      containerPort = number<br/>      hostPort      = optional(number)<br/>      protocol      = optional(string, "tcp")<br/>    })), [])<br/>    logConfiguration = optional(object({<br/>      logDriver = string<br/>      options   = map(string)<br/>    }), null)<br/>    essential = optional(bool, true)<br/>  }))</pre> | `{}` | no |
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
| <a name="input_path"></a> [path](#input\_path) | The path for the IAM role. | `string` | `null` | no |
| <a name="input_ecs_secrets_permissions"></a> [ecs\_secrets\_permissions](#input\_ecs\_secrets\_permissions) | Permissions for accessing secrets in ECS tasks | <pre>object({<br/>    actions = optional(list(string), [<br/>      "secretsmanager:GetSecretValue",<br/>      "secretsmanager:DescribeSecret"<br/>    ])<br/>  })</pre> | <pre>{<br/>  "actions": [<br/>    "secretsmanager:GetSecretValue",<br/>    "secretsmanager:DescribeSecret"<br/>  ]<br/>}</pre> | no |
| <a name="input_ecs_execution_kms_permissions"></a> [ecs\_execution\_kms\_permissions](#input\_ecs\_execution\_kms\_permissions) | KMS permissions for ECS task execution role | <pre>object({<br/>    actions = optional(list(string), [<br/>      "kms:Decrypt",<br/>      "kms:DescribeKey"<br/>    ])<br/>  })</pre> | <pre>{<br/>  "actions": [<br/>    "kms:Decrypt",<br/>    "kms:DescribeKey"<br/>  ]<br/>}</pre> | no |
| <a name="input_ecs_execution_efs_permissions"></a> [ecs\_execution\_efs\_permissions](#input\_ecs\_execution\_efs\_permissions) | EFS permissions for ECS task execution role | <pre>object({<br/>    actions = optional(list(string), [<br/>      "elasticfilesystem:ClientMount",<br/>      "elasticfilesystem:ClientWrite",<br/>      "elasticfilesystem:ClientRead",<br/>      "elasticfilesystem:ClientRootAccess"<br/>    ])<br/>  })</pre> | <pre>{<br/>  "actions": [<br/>    "elasticfilesystem:ClientMount",<br/>    "elasticfilesystem:ClientWrite",<br/>    "elasticfilesystem:ClientRead",<br/>    "elasticfilesystem:ClientRootAccess"<br/>  ]<br/>}</pre> | no |
| <a name="input_execution_policy_name"></a> [execution\_policy\_name](#input\_execution\_policy\_name) | The name of the IAM policy. | `string` | `null` | no |
| <a name="input_task_policy_name"></a> [task\_policy\_name](#input\_task\_policy\_name) | The name of the IAM policy for the task role. | `string` | `null` | no |
| <a name="input_execution_role_custom_policies"></a> [execution\_role\_custom\_policies](#input\_execution\_role\_custom\_policies) | List of custom policy ARNs to attach to ECS task execution role | `list(string)` | `[]` | no |
| <a name="input_ecs_efs_s3_kms_arns"></a> [ecs\_efs\_s3\_kms\_arns](#input\_ecs\_efs\_s3\_kms\_arns) | List of KMS key ARNs used by the containerized app to decrypt data.<br/>ARN of KMS key used by the containerized app to decrypt data you explicitly encrypted with KMS for the files stored in EFS volume; ARN of the KMS key used by ECS task to read files from S3 buckets that are encrypted with SSE‑KMS; ARN of KMS key used for any client‑side encryption where the container performs decryption. | `list(string)` | `[]` | no |
| <a name="input_ecs_task_kms_permissions"></a> [ecs\_task\_kms\_permissions](#input\_ecs\_task\_kms\_permissions) | KMS permissions for ECS task role | <pre>object({<br/>    actions = optional(list(string), [<br/>      "kms:Decrypt",<br/>      "kms:DescribeKey"<br/>    ])<br/>  })</pre> | <pre>{<br/>  "actions": [<br/>    "kms:Decrypt",<br/>    "kms:DescribeKey"<br/>  ]<br/>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region or availability zone (e.g., us-west-1a, eu-west-2). Optional, used for regional resources. | `string` | `""` | no |
| <a name="input_ecs_task_cloudwatch_permissions"></a> [ecs\_task\_cloudwatch\_permissions](#input\_ecs\_task\_cloudwatch\_permissions) | CloudWatch Logs permissions for ECS task role | <pre>object({<br/>    actions   = optional(list(string), ["logs:CreateLogGroup"])<br/>    resources = optional(list(string), ["*"])<br/>  })</pre> | `null` | no |
| <a name="input_enable_ecs_task_cloudwatch_permissions"></a> [enable\_ecs\_task\_cloudwatch\_permissions](#input\_enable\_ecs\_task\_cloudwatch\_permissions) | Whether to enable CloudWatch Logs permissions for ECS task role when not explicitly provided | `bool` | `false` | no |
| <a name="input_ecs_task_ssm_permissions"></a> [ecs\_task\_ssm\_permissions](#input\_ecs\_task\_ssm\_permissions) | SSM Session Manager permissions for ECS task role | <pre>object({<br/>    actions = optional(list(string), [<br/>      "ssmmessages:*",<br/>      "ssm:UpdateInstanceInformation",<br/>      "ssm:StartSession",<br/>      "ssm:DescribeSessions",<br/>      "ssm:GetConnectionStatus"<br/>    ])<br/>    resources = optional(list(string), ["*"])<br/>  })</pre> | `null` | no |
| <a name="input_enable_ecs_task_ssm_permissions"></a> [enable\_ecs\_task\_ssm\_permissions](#input\_enable\_ecs\_task\_ssm\_permissions) | Whether to enable SSM Session Manager permissions for ECS task role when not explicitly provided | `bool` | `false` | no |
| <a name="input_ecs_task_appconfig_permissions"></a> [ecs\_task\_appconfig\_permissions](#input\_ecs\_task\_appconfig\_permissions) | AppConfig permissions for ECS task role | <pre>object({<br/>    actions = optional(list(string), [<br/>      "appconfig:StartConfigurationSession",<br/>      "appconfig:GetConfiguration",<br/>      "appconfig:GetConfigurationProfile",<br/>      "appconfig:GetLatestConfiguration",<br/>      "appconfig:GetApplication",<br/>      "appconfig:GetEnvironment",<br/>      "appconfig:ListApplications",<br/>      "appconfig:ListConfigurationProfiles",<br/>      "appconfig:ListEnvironments",<br/>      "appconfig:GetDeployment",<br/>      "appconfig:ListDeployments"<br/>    ])<br/>    resources = optional(list(string), ["*"])<br/>  })</pre> | `null` | no |
| <a name="input_enable_ecs_task_appconfig_permissions"></a> [enable\_ecs\_task\_appconfig\_permissions](#input\_enable\_ecs\_task\_appconfig\_permissions) | Whether to enable AppConfig permissions for ECS task role when not explicitly provided | `bool` | `false` | no |
| <a name="input_ecs_task_s3_permissions"></a> [ecs\_task\_s3\_permissions](#input\_ecs\_task\_s3\_permissions) | S3 permissions for ECS task role | <pre>object({<br/>    actions = optional(list(string), [<br/>      "s3:GetObject",<br/>      "s3:PutObject",<br/>      "s3:DeleteObject",<br/>      "s3:ListBucket",<br/>      "s3:GetBucketLocation",<br/>      "s3:GetObjectVersion",<br/>      "s3:PutObjectAcl"<br/>    ])<br/>  })</pre> | `null` | no |
| <a name="input_enable_ecs_task_s3_permissions"></a> [enable\_ecs\_task\_s3\_permissions](#input\_enable\_ecs\_task\_s3\_permissions) | Whether to enable S3 permissions for ECS task role when not explicitly provided | `bool` | `false` | no |
| <a name="input_ecs_task_efs_permissions"></a> [ecs\_task\_efs\_permissions](#input\_ecs\_task\_efs\_permissions) | EFS permissions for ECS task role | <pre>object({<br/>    actions = optional(list(string), [<br/>      "elasticfilesystem:ClientMount",<br/>      "elasticfilesystem:ClientWrite",<br/>      "elasticfilesystem:ClientRootAccess",<br/>      "elasticfilesystem:DescribeAccessPoints",<br/>      "elasticfilesystem:DescribeFileSystems"<br/>    ])<br/>  })</pre> | `null` | no |
| <a name="input_enable_ecs_task_efs_permissions"></a> [enable\_ecs\_task\_efs\_permissions](#input\_enable\_ecs\_task\_efs\_permissions) | Whether to enable EFS permissions for ECS task role when not explicitly provided | `bool` | `false` | no |
| <a name="input_ecs_task_efs_s3_permissions"></a> [ecs\_task\_efs\_s3\_permissions](#input\_ecs\_task\_efs\_s3\_permissions) | S3 permissions for EFS integration with ECS task role | <pre>object({<br/>    actions = optional(list(string), ["s3:GetObject"])<br/>  })</pre> | `null` | no |
| <a name="input_enable_ecs_task_efs_s3_permissions"></a> [enable\_ecs\_task\_efs\_s3\_permissions](#input\_enable\_ecs\_task\_efs\_s3\_permissions) | Whether to enable S3 permissions for EFS integration with ECS task role when not explicitly provided | `bool` | `false` | no |

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
| <a name="output_ecs_task_execution_role_unique_id"></a> [ecs\_task\_execution\_role\_unique\_id](#output\_ecs\_task\_execution\_role\_unique\_id) | The unique ID of the created ECS task execution role (if created) |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | The ARN of the created ECS task role (if created) |
| <a name="output_ecs_task_role_name"></a> [ecs\_task\_role\_name](#output\_ecs\_task\_role\_name) | The name of the created ECS task role (if created) |
| <a name="output_ecs_task_role_id"></a> [ecs\_task\_role\_id](#output\_ecs\_task\_role\_id) | The unique ID of the created ECS task role (if created) |
| <a name="output_ecs_task_role_unique_id"></a> [ecs\_task\_role\_unique\_id](#output\_ecs\_task\_role\_unique\_id) | The unique ID of the created ECS task role (if created) |
| <a name="output_ecs_task_role_create_date"></a> [ecs\_task\_role\_create\_date](#output\_ecs\_task\_role\_create\_date) | The creation date of the created ECS task role (if created) |
| <a name="output_ecs_task_role_tags"></a> [ecs\_task\_role\_tags](#output\_ecs\_task\_role\_tags) | The tags applied to the created ECS task role (if created) |
| <a name="output_ecs_task_role_custom_policy_arns"></a> [ecs\_task\_role\_custom\_policy\_arns](#output\_ecs\_task\_role\_custom\_policy\_arns) | Map of custom policy names to their ARNs for the ECS task role |
| <a name="output_ecs_task_role_custom_policy_names"></a> [ecs\_task\_role\_custom\_policy\_names](#output\_ecs\_task\_role\_custom\_policy\_names) | Map of custom policy names to their names for the ECS task role |
| <a name="output_ecs_task_role_custom_policy_ids"></a> [ecs\_task\_role\_custom\_policy\_ids](#output\_ecs\_task\_role\_custom\_policy\_ids) | Map of custom policy names to their IDs for the ECS task role |
| <a name="output_container_names"></a> [container\_names](#output\_container\_names) | List of container names in the task definition |
| <a name="output_container_definitions"></a> [container\_definitions](#output\_container\_definitions) | The container definitions in JSON format |
| <a name="output_task_definition_tags_all"></a> [task\_definition\_tags\_all](#output\_task\_definition\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block |
| <a name="output_track_latest"></a> [track\_latest](#output\_track\_latest) | Whether the ECS service tracks the latest ACTIVE revision |
| <a name="output_placement_constraints"></a> [placement\_constraints](#output\_placement\_constraints) | The placement constraints for the task |
| <a name="output_volumes"></a> [volumes](#output\_volumes) | The volume configuration for the task |
<!-- END_TF_DOCS -->
