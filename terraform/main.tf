################################################################################
# ECR Rrpository
###############################################################################
module "ecr" {
  source = "../modules/ecr"

  for_each = { for repo in var.ecr : repo.repository_name => repo }

  repository_name               = "${local.identifier}-${each.value.repository_name}"
  repository_image_tag_mutability = each.value.repository_image_tag_mutability
  repository_encryption_type    = each.value.repository_encryption_type
  repository_force_delete       = each.value.repository_force_delete
  repository_image_scan_on_push = each.value.repository_image_scan_on_push
}

################################################################################
# VPC
################################################################################
module "vpc" {
  source = "../modules/vpc"

  name                   = "${local.identifier}"
  cidr                   = var.vpc.cidr
  azs                    = local.azs
  enable_nat_gateway     = var.vpc.enable_nat_gateway
  single_nat_gateway     = var.vpc.single_nat_gateway
  one_nat_gateway_per_az = var.vpc.one_nat_gateway_per_az

  map_public_ip_on_launch = var.vpc.map_public_ip_on_launch

  private_subnets = [for i in range(0, local.num_private_subnets) : cidrsubnet(var.vpc.cidr, var.vpc.subnet_bits, i)]
  public_subnets  = [for i in range(local.num_private_subnets, local.num_private_subnets + local.num_public_subnets) : cidrsubnet(var.vpc.cidr, var.vpc.subnet_bits, i)]

  public_subnet_names = [
    for i in range(0, length(local.azs)) :
    "${local.identifier}-public-${element(local.azs, i)}"
  ]
  private_subnet_names = [
    for i in range(0, length(local.azs)) :
    "${local.identifier}-private-${element(local.azs, i)}"
  ]
}

################################################################################
# Cluster
################################################################################
module "cluster" {
  source = "../modules/ecs"

  name                  = "${local.identifier}"
  region                = var.region
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnets
  private_subnet_ids    = module.vpc.private_subnets
  image                 = var.ecs_cluster.image
  container_port        = var.ecs_cluster.container_port
  task_cpu              = var.ecs_cluster.task_cpu
  task_memory           = var.ecs_cluster.task_memory
  cpu_architecture      = var.ecs_cluster.cpu_architecture
  desired_count         = var.ecs_cluster.desired_count
  assign_public_ip      = var.ecs_cluster.assign_public_ip
  health_check_path     = var.ecs_cluster.health_check_path
  container_healthcheck = var.ecs_cluster.container_healthcheck
  environment           = var.ecs_cluster.environment
  log_retention_days    = var.ecs_cluster.log_retention_days
}
