# =============================================================================
# S3 Artifacts Module - Security Reports Storage
# =============================================================================

# S3 Bucket for Security Artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project_name}-security-artifacts-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.tags, {
    Name    = "${var.project_name}-security-artifacts"
    Purpose = "Security scan reports and artifacts"
  })
}

data "aws_caller_identity" "current" {}

# Bucket Versioning
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket                  = aws_s3_bucket.artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle Rules - Keep artifacts for 90 days
resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "cleanup-old-artifacts"
    status = "Enabled"

    expiration {
      days = 90
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# Create folder structure for each environment
resource "aws_s3_object" "dev_folder" {
  bucket  = aws_s3_bucket.artifacts.id
  key     = "dev/"
  content = ""
}

resource "aws_s3_object" "uat_folder" {
  bucket  = aws_s3_bucket.artifacts.id
  key     = "uat/"
  content = ""
}

resource "aws_s3_object" "prod_folder" {
  bucket  = aws_s3_bucket.artifacts.id
  key     = "prod/"
  content = ""
}
