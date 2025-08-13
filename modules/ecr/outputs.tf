output "repository_name" {
  description = "Name of the repository"
  value       = aws_ecr_repository.ecr.name 
}

output "repository_arn" {
  description = "Full ARN of the repository"
  value       = aws_ecr_repository.ecr.arn 
}

output "repository_registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.ecr.registry_id 
}

output "repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.ecr.repository_url 
}
