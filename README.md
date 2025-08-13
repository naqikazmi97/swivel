# SWIVEL - AWS Infrastructure Project

A Terraform project that deploys a web application on AWS using ECS Fargate, ECR, and VPC.

## What it does

- Creates an ECR repository for Docker images
- Sets up a VPC with public and private subnets
- Deploys a web app on ECS Fargate
- Uses nginx to serve a simple HTML page
- Configures OIDC role for GitHub Actions workflows

## Prerequisites

Before you begin, make sure you have:

- **AWS Account** with appropriate permissions
- **AWS CLI** installed and configured
- **Terraform** ~> 1.10 installed
- **Docker** installed (for building images)
- **OIDC Role** configured in AWS for GitHub Actions authentication

## Project Structure

```
├── Dockerfile          # Container definition
├── index.html         # Web app
├── nginx/             # Nginx config
├── modules/           # Terraform modules
└── terraform/         # Main Terraform files
```

## GitHub Actions Workflows

The project includes two automated workflows that need to be triggered manually:

1. **Terraform Deployment** - Deploys infrastructure changes automatically
   - Use when: Making changes to VPC, ECS, ECR, or other AWS resources
   - What it does: Runs `terraform plan` and `terraform apply`
   - Triggers: Manual workflow dispatch
   - Environment: Uses OIDC role for AWS authentication

2. **Application Deployment** - Builds Docker image, pushes to ECR, and updates ECS service
   - Use when: Updating application code or container configuration
   - What it does: Builds Docker image, pushes to ECR, updates ECS task definition
   - Triggers: Manual workflow dispatch
   - Environment: Uses OIDC role for AWS authentication