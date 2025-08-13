variable "identifier" {
  description = "Name of the project"
  type        = string
  default     = "swivel"
}

variable "env" {
  description = "Name of the environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Name of the region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = null
}

################################################################################
# ECR Repository
################################################################################
variable "ecr" {
  description = "List of ECR repository configurations"
  type = list(object({
    repository_name             = string
    repository_image_tag_mutability = string
    repository_encryption_type  = string
    repository_force_delete     = bool
    repository_image_scan_on_push = bool
  }))
}

################################################################################
# VPC
################################################################################
# Each subnet will be /24 masked if VPC cidr is /16. This adds the 8 into /16 to create /24 subnet bits.
variable "vpc" {
  description = "VPC configurations"
  type = object({
    name                    = string
    cidr                    = string
    enable_nat_gateway      = bool
    single_nat_gateway      = bool
    one_nat_gateway_per_az  = bool
    map_public_ip_on_launch = bool
    number_of_az            = number
    subnet_bits             = number
  })
}

################################################################################
# ECS
################################################################################
variable "ecs_cluster" {
  description = "Configuration for the ECS Fargate cluster."
  type = object({
    image                 = string
    container_port        = number
    task_cpu              = string
    task_memory           = string
    cpu_architecture      = string
    desired_count         = number
    assign_public_ip      = bool
    health_check_path     = string
    container_healthcheck = object({
      command      = optional(list(string))
      interval     = number
      timeout      = number
      retries      = number
      start_period = number
    })
    environment        = optional(map(string))
    log_retention_days = number
  })
}
