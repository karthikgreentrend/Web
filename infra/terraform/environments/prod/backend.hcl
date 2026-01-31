# =============================================================================
# PROD Environment Backend Configuration
# =============================================================================

bucket         = "terraform-state-bucket-prod"  # Replace with your S3 bucket
key            = "web-app/prod/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-state-locks-prod"   # Replace with your DynamoDB table
