# =============================================================================
# DEV Environment Backend Configuration
# =============================================================================

bucket         = "terraform-state-bucket-dev"  # Replace with your S3 bucket
key            = "web-app/dev/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-state-locks-dev"   # Replace with your DynamoDB table
