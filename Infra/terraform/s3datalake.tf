resource "aws_s3_bucket" "s3_datalake" {
  bucket = "coretelecoms-cx-datalake"
  tags = merge(local.general, local.airflow_service)

}

#s3 Versioning
resource "aws_s3_bucket_versioning" "s3_version" {
  bucket = aws_s3_bucket.s3_datalake.id

  versioning_configuration {
    status = "Enabled"
  }
}

# small object to create folder marker 
resource "aws_s3_object" "s3_raw_folder" {
  bucket = aws_s3_bucket.s3_datalake.id
  key    = "raw/"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "s3_datalake_encryption" {
  bucket = aws_s3_bucket.s3_datalake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 LIFECYCLE RULES
resource "aws_s3_bucket_lifecycle_configuration" "s3_datalake_lifecycle" {
  count  = var.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.s3_datalake.id

  # 1. Transition to STANDARD_IA
  rule {
    id     = "transition-ia"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = var.s3_transition_ia_days
      storage_class = "STANDARD_IA"
    }
  }

  # 2. Transition to GLACIER Instant Retrieval
  rule {
    id     = "transition-glacier"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = var.s3_transition_glacier_days
      storage_class = "GLACIER_IR"
    }
  }

  # 3. Noncurrent version expiration
  rule {
    id     = "noncurrent-cleanup"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = var.s3_noncurrent_version_expiration_days
    }
  }

  # 4. Expire all objects after X days
  rule {
    id     = "expire-all"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = var.s3_expiration_days
    }
  }

  # 5. Abort incomplete multipart uploads
  rule {
    id     = "abort-multipart"
    status = "Enabled"

    filter {
      prefix = ""
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# VPC MODULE
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "coretelecoms-cx-vpc"
  cidr = "172.16.0.0/16"     

  azs = ["eu-north-1a", "eu-north-1b"]

  
  private_subnets = ["172.16.1.0/24", "172.16.2.0/24"]
  public_subnets  = ["172.16.101.0/24", "172.16.102.0/24"]

  enable_nat_gateway = false   # COST EFFECTIVE
  single_nat_gateway = false
  enable_vpn_gateway = false

  tags = local.general
}

# BLOCK PUBLIC ACCESS

resource "aws_s3_bucket_public_access_block" "s3_datalake_block" {
  bucket = aws_s3_bucket.s3_datalake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}