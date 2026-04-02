locals {
  resource_name_configs = {
    execution = {
      cloud_resource_type = var.cloud_resource_type_execution
    }
    task = {
      cloud_resource_type = var.cloud_resource_type_task
    }
    policy = {
      cloud_resource_type = var.cloud_resource_type_policy
    }
  }
}
