# Snowflake Password
# This a placeholder. The value must be updatde manually in AWS Console.
resource "aws_ssm_parameter" "ct_snowflake_password" {
  name        = "/coretelecoms-cx/snowflake/password"
  description = "Password for Snowflake Airflow user"
  type        = "SecureString"
  value       = "CHANGE_ME_IN_CONSOLE"

  # To prevent Terraform from overwriting the updated password
  lifecycle {
    ignore_changes = [value]
  }
}

# Snowflake account ID/URL
resource "aws_ssm_parameter" "ct_snowflake_account" {
  name        = "/coretelecoms-cx/snowflake/account"
  description = "Snowflake Account ID"
  type        = "SecureString"
  value       = "CHANGE_ME_IN_CONSOLE"

  lifecycle {
    ignore_changes = [value]
  }
}

# Snowflake Warehouse
resource "aws_ssm_parameter" "ct_snowflake_warehouse" {
  name  = "/coretelecoms-cx/snowflake/warehouse"
  type  = "String"
  value = "coretelecoms-cx-datawarehouse"
}

# Snowflake Database
resource "aws_ssm_parameter" "ct_snowflake_database" {
  name  = "/coretelecoms-cx/snowflake/database"
  type  = "String"
  value = "coretelecoms"
}

# Snowflake Role
resource "aws_ssm_parameter" "ct_snowflake_role" {
  name  = "/coretelecoms-cx/snowflake/role"
  type  = "String"
  value = "core_data_engineering"
}

# Postgres Password (Source DB)
resource "aws_ssm_parameter" "ct_postgres_password" {
  name        = "/coretelecoms-cx/postgres/postgres_password"
  description = "Password for the upstream Source Postgres DB"
  type        = "SecureString"
  value       = "CHANGE_ME_IN_CONSOLE"

  lifecycle {
    ignore_changes = [value]
  }
}
