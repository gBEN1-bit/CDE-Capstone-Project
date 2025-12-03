terraform {
  backend "s3" {
    bucket       = "coretelecom-cx-terraform-state"
    key          = "production/coretelecoms-cx/terraform.tfstate"
    use_lockfile = true
    region       = "eu-north-1"
  }
}