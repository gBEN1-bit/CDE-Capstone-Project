#For Tags
locals {
  service = {
    Name = "Airflow"
  }
}

#s3 datalake
resource "aws_s3_bucket" "s3datalake" {
  bucket = "coretelecoms-cx-datalake-raw"

  tags = merge(
    local.service,
    local.general
  )
}

#s3 Versioning
resource "aws_s3_bucket_versioning" "s3version" {
  bucket = aws_s3_bucket.s3datalake.id
  versioning_configuration {
    status = "Enabled"
  }
}

#  Creating folders in S3
resource "aws_s3_object" "cx_raw_folder" {
  bucket = aws_s3_bucket.s3datalake.bucket
  key    = "raw/"
  
}