#s3 for terraform statefile
resource "aws_s3_bucket" "terraformstatefile" {
  bucket = "coretelecoms-cx-terraform-state"
  tags   = local.general

}

terraform {
  backend "s3" {
    bucket       = "coretelecoms-cx-terraform-state"
    key          = "production/coretelecoms-cx/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
    region       = "eu-north-1"
    profile      = "deprojects"
  }
}

