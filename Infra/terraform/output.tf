output "ct_airflow_iam_access_key_id" {
  description = "Airflow Access key for Local Dev"
  value       = aws_iam_access_key.ct_airflow_local_key.id
  sensitive   = true
}

output "ct_airflow_iam_access_secret_key" {
  description = "Airflow Secret key for Local Dev"
  value       = aws_iam_access_key.ct_airflow_local_key.secret
  sensitive   = true
}

output "ct_snowflake_role_arn" {
  description = "ARN of the Snowflake Access Role (Use this in CREATE STORAGE INTEGRATION)"
  value       = aws_iam_role.ct_snowflake_s3_role.arn
}
