variable "name" {
  description = "The base name for the ECS cluster and related resources."
  type        = string
}

variable "region" {
  description = "AWS region where the resources will be deployed."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC in which ECS resources will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ECS tasks or load balancer."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS tasks."
  type        = list(string)
}

variable "image" {
  description = "The container image to use, e.g., <acct>.dkr.ecr.<region>.amazonaws.com/hello:latest."
  type        = string
}

variable "container_port" {
  description = "Port on which the container listens."
  type        = number
  default     = 80
}

# Task sizing
variable "task_cpu" {
  description = "The amount of CPU (in CPU units) to allocate to the ECS task (e.g., 512 = 0.5 vCPU)."
  type        = string
  default     = "512"
}

variable "task_memory" {
  description = "The amount of memory (in MiB) to allocate to the ECS task (e.g., 1024 = 1 GB)."
  type        = string
  default     = "1024"
}

variable "cpu_architecture" {
  description = "The CPU architecture for the ECS task (X86_64 or ARM64). Must match your container image."
  type        = string
  default     = "X86_64"
}

variable "desired_count" {
  description = "The desired number of ECS tasks to run."
  type        = number
  default     = 1
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to ECS tasks."
  type        = bool
  default     = false
}

variable "health_check_path" {
  description = "Path for the load balancer health check."
  type        = string
  default     = "/"
}

variable "container_healthcheck" {
  description = <<EOT
Container-level health check configuration.
Fields:
  command      : List of strings representing the health check command.
  interval     : Time (in seconds) between health checks.
  timeout      : Time (in seconds) to wait before failing the check.
  retries      : Number of retries before marking container unhealthy.
  start_period : Time (in seconds) before starting health checks after container starts.
EOT
  type = object({
    command      = list(string)
    interval     = number
    timeout      = number
    retries      = number
    start_period = number
  })
  default = null
}

variable "environment" {
  description = "A map of environment variables to pass to the ECS container."
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "Number of days to retain ECS task logs in CloudWatch."
  type        = number
  default     = 14
}

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}
