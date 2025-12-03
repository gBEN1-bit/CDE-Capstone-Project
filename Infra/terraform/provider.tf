terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = ">= 1.0.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region  = "eu-north-1"
  profile = "default"
}



# # A simple configuration of the provider with a default authentication.
# # A default value for `authenticator` is `snowflake`, enabling authentication with `user` and `password`.
# provider "snowflake" {
#   organization_name = var.organization_name  # required if not using profile. Can also be set via SNOWFLAKE_ORGANIZATION_NAME env var
#   account_name      = var.account_name # required if not using profile. Can also be set via SNOWFLAKE_ACCOUNT_NAME env var
#   user              = var.user_name # required if not using profile or token. Can also be set via SNOWFLAKE_USER env var
#   password          = var.password

#   // optional
#   role              = "PUBLIC"
#   host      = "..."
#   warehouse = "..."
#   params = {
#     query_tag = "..."
#   }
# }



# # A simple configuration of the provider with a default authentication.
# # A default value for `authenticator` is `snowflake`, enabling authentication with `user` and `password`.
# provider "snowflake" {
#   organization_name = "..." # required if not using profile. Can also be set via SNOWFLAKE_ORGANIZATION_NAME env var
#   account_name      = "..." # required if not using profile. Can also be set via SNOWFLAKE_ACCOUNT_NAME env var
#   user              = "..." # required if not using profile or token. Can also be set via SNOWFLAKE_USER env var
#   password          = "..."

#   // optional
#   role      = "..."
#   host      = "..."
#   warehouse = "..."
#   params = {
#     query_tag = "..."
#   }
# }

# provider "snowflake" {
#   account  = var.snowflake_account
#   username = var.snowflake_user
#   password = var.snowflake_password
#   role     = var.snowflake_role
#   region   = "AWS_EU_NORTH_1"
# }
