################################################################################
# Repository
################################################################################
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "repository_image_tag_mutability" {
  description = "Image tag mutability for the repository"
  type        = string
}

variable "repository_encryption_type" {
  description = "Encryption type for the repository"
  type        = string
}

variable "repository_force_delete" {
  description = "Flag to force delete the repository"
  type        = bool
}

variable "repository_image_scan_on_push" {
  description = "Flag to enable image scanning on push"
  type        = bool
}

