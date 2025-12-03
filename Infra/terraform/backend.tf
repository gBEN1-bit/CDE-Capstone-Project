#s3 for terraform statefile
resource "aws_s3_bucket" "terraformstatefile" {
  bucket = "coretelecom-cx-terraform-state"
  tags   = local.general

}

terraform {
  backend "s3" {
    bucket       = "coretelecom-cx-terraform-state"
    key          = "production/coretelecoms-cx/terraform.tfstate"
    use_lockfile = true
    region       = "eu-north-1"
    profile      = "default"
  }
}