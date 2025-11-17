# ECS Task Definition Module Examples

This directory contains comprehensive examples demonstrating the capabilities of the ECS task definition module. Each example showcases different use cases and configuration patterns.

## Available Examples

### 1. [Simple](./simple/)
**Basic ECS task definition configuration**
- Core module variables and naming conventions
- Single container definition setup
- Environment variables and port mappings
- Basic task family configuration

## Features Demonstrated

### Core Module Features
- ✅ **Family naming**: Task definition family configuration
- ✅ **Container definitions**: Basic container setup with image, environment, and ports
- ✅ **Naming conventions**: Standardized resource naming using org/project/env patterns
- ✅ **Tagging**: Resource tagging for organization

## Running the Examples

Each example includes:
- `main.tf`: Module usage and supporting resources
- `variables.tf`: Configurable parameters with defaults
- `outputs.tf`: Useful outputs for integration
- `versions.tf`: Provider requirements
- `terraform.tfvars`: Example variable values

### Quick Start

```bash
# Navigate to the example
cd examples/simple

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan

# Apply configuration (requires AWS credentials)
terraform apply
```

### Validating Examples

```bash
# Validate the simple example
cd examples/simple
terraform init -backend=false
terraform validate
```

## Module Capability Coverage

The simple example provides basic coverage:

- **Core ECS task definition** functionality
- **Container configuration** with environment and ports
- **Standardized naming** conventions
- **Basic setup** for getting started with the module
