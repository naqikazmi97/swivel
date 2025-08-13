terraform {
  backend "s3" {
    bucket       = "centralised-terraform-state"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
