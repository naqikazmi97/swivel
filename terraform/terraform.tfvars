################################################################################
# ECR Repository
################################################################################
ecr = [
    {
        repository_name = "app"
        repository_image_tag_mutability = "MUTABLE"
        repository_encryption_type = "AES256"
        repository_force_delete = false
        repository_image_scan_on_push = true
        tags = {
            version = "1.0"
        }
    }
]

################################################################################
# VPC
################################################################################
vpc = {
  cidr                    = "10.199.0.0/16"
  enable_nat_gateway      = true
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false
  map_public_ip_on_launch = true
  number_of_az            = 2
  subnet_bits             = 8
}

################################################################################
# ECS
################################################################################
ecs_cluster = {
  image                 = "719037119533.dkr.ecr.us-east-1.amazonaws.com/swivel-dev-app:latest"
  container_port        = 80
  task_cpu              = "512"
  task_memory           = "1024"
  cpu_architecture      = "X86_64"
  desired_count         = 1
  assign_public_ip      = false
  health_check_path     = "/"
  environment = {
    "app" = "hello_world"
  }
  container_healthcheck = {
    command      = ["CMD-SHELL", "wget -qO- http://localhost:80/ || exit 1"]
    interval     = 30
    timeout      = 5
    retries      = 3
    start_period = 10
  }
  log_retention_days = 7
}
