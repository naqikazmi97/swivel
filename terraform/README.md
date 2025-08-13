# Terraform Configuration

This directory contains the main Terraform configuration for the SWIVEL project.

## Files

- **main.tf** - Main infrastructure definition (ECR, VPC, ECS)
- **variables.tf** - Variable definitions and types
- **terraform.tfvars** - Variable values and configuration
- **versions.tf** - Terraform and provider version constraints
- **backend.tf** - Backend configuration for state storage
- **data.tf** - Data sources for external resources
- **locals.tf** - Local values and computed variables
- **provider.tf** - AWS provider configuration

## Usage

1. **Initialize** - `terraform init`
2. **Plan** - `terraform plan`
3. **Apply** - `terraform apply`
4. **Destroy** - `terraform destroy`

## Configuration

Edit `terraform.tfvars` to customize:
- VPC CIDR blocks and subnet configuration
- ECS task specifications (CPU, memory, count)
- ECR repository settings
- Environment-specific values

## Modules Used

- **ECR Module** - Container registry management
- **VPC Module** - Network infrastructure
- **ECS Module** - Container orchestration 