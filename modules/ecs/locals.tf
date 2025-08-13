locals {
  name            = var.name
  labels          = merge({ app = var.name}, var.tags)
  container_port  = var.container_port
  task_cpu        = var.task_cpu
  task_memory     = var.task_memory
  family          = var.name
  log_group_name  = "/ecs/${local.family}"
}