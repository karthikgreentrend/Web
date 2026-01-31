# =============================================================================
# UAT Environment Backend Configuration
# =============================================================================

bucket         = "terraform-state-bucket-uat"  # Replace with your S3 bucket
key            = "web-app/uat/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-state-locks-uat"   # Replace with your DynamoDB table
