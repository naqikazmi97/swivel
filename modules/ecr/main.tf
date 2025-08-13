################################################################################
# Repository
################################################################################
resource "aws_ecr_repository" "ecr" {
  name                 = var.repository_name
  image_tag_mutability = var.repository_image_tag_mutability

  encryption_configuration {
    encryption_type = var.repository_encryption_type
  }

  force_delete = var.repository_force_delete

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }

}