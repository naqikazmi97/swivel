# Terraform Modules

This directory contains reusable Terraform modules for the SWIVEL project.

## Available Modules

### ECR Module (`ecr/`)
Manages Amazon Elastic Container Registry repositories.

**Features:**
- Repository creation and configuration
- Image scanning on push
- Encryption settings
- Tag mutability configuration

### VPC Module (`vpc/`)
Creates and configures Amazon Virtual Private Cloud.

**Features:**
- Public and private subnets
- NAT Gateway configuration
- Route table management
- Availability zone distribution

### ECS Module (`ecs/`)
Deploys Amazon ECS Fargate services.

**Features:**
- Fargate cluster and service
- Load balancer integration
- Auto-scaling configuration
- CloudWatch logging

## Module Structure

Each module follows standard Terraform module structure:
- `main.tf` - Main resource definitions
- `variables.tf` - Input variable definitions
- `outputs.tf` - Output values
- `locals.tf` - Local computed values (if applicable) 