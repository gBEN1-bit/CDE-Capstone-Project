resource "aws_iam_policy" "ct_airflow_policy" {
  name        = "coretelecoms-cx-airflow-policy"
  description = "Permissions for Airflow to access S3 and SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Access to s3 DataLake Buckets
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [

         # Access to Destination s3 bucket 
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*",

          # Access to Source s3 bucket 
          "arn:aws:s3:::core-telecoms-data-lake",
          "arn:aws:s3:::core-telecoms-data-lake/*",
        ]
      },
      # Access to SSM Parameters
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:ssm:${var.aws_region}:*:parameter/coretelecoms-cx/*"
      }

    ]
  })
}

# Production Identity
# To be used if airflow gets deployed to production (EC2)
data "aws_iam_policy_document" "ct_airflow_ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ct_airflow_execution_role" {
  name = "ct_airflow_execution_role"

  assume_role_policy = data.aws_iam_policy_document.ct_airflow_ec2_trust.json

  tags = {
    Purpose = "Coretelecoms-CX Airflow Production Execution"
    Owner   = "DataEngineering"
  }
}

# Attach Policy to role
resource "aws_iam_role_policy_attachment" "ct_role_attach" {
  role       = aws_iam_role.ct_airflow_execution_role.name
  policy_arn = aws_iam_policy.ct_airflow_policy.arn
}

# Local Airflow Identity
# To be used for local airflow development
resource "aws_iam_user" "ct_airflow_local_user" {
  name = "ct_airflow_local_dev"

  tags = {
    Purpose = "Airflow Local Development"
  }
}

resource "aws_iam_user_policy_attachment" "ct_user_attach" {
  user       = aws_iam_user.ct_airflow_local_user.name
  policy_arn = aws_iam_policy.ct_airflow_policy.arn
}


resource "aws_iam_access_key" "ct_airflow_local_key" {
  user = aws_iam_user.ct_airflow_local_user.name
}

# Get Current Account ID
# This allows us to trust "Self" if the Snowflake ARN isn't known yet.
data "aws_caller_identity" "ct_current" {}

# Trust Policy for Snowflake
data "aws_iam_policy_document" "ct_snowflake_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      # Fails the first time due to dummy data, it uses my ARN, then when placeholder is replaced, it uses the valid snowflake arn
      identifiers = [
        var.snowflake_account_arn == "arn:aws:iam::123456789012:root"
        ? "arn:aws:iam::${data.aws_caller_identity.ct_current.account_id}:root"
        : var.snowflake_account_arn
      ]
    }

    # only allow if external ID matches
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.snowflake_external_id]
    }
  }
}

# create snowflake role
resource "aws_iam_role" "ct_snowflake_s3_role" {
  name               = "coretelecoms-cx-snowflake-role"
  assume_role_policy = data.aws_iam_policy_document.ct_snowflake_trust.json

  tags = {
    Purpose = "Snowflake Integration"
  }
}

# Permissions policy, to grant read access to raw bucket
resource "aws_iam_policy" "ct_snowflake_s3_policy" {
  name        = "coretelecoms-cx-snowflake-s3-access"
  description = "Allow Snowflake to read from Raw S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_bucket_name}",
          "arn:aws:s3:::${var.s3_bucket_name}/*",
        ]
      }
    ]
  })

}

# attach policy
resource "aws_iam_role_policy_attachment" "ct_snowflake_attach" {
  role       = aws_iam_role.ct_snowflake_s3_role.name
  policy_arn = aws_iam_policy.ct_snowflake_s3_policy.arn

}
