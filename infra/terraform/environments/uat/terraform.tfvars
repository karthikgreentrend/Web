# =============================================================================
# UAT Environment Configuration
# Branch: release -> Environment: uat
# =============================================================================

environment = "uat"
git_branch  = "release"

# AWS Region
aws_region = "us-east-1"

# Project
project_name = "web-app"

# Domain Configuration
domain_name        = "example.com"  # Replace with your domain
create_hosted_zone = false           # Set to true if you need to create a new zone
hosted_zone_id     = ""              # Provide existing zone ID if create_hosted_zone is false

# VPC Configuration
vpc_cidr           = "10.1.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]

# Application
app_port          = 3000
health_check_path = "/health"

# Features
enable_s3_hosting  = true
enable_cloudfront  = true
create_certificate = true

# CloudFront
cloudfront_price_class = "PriceClass_100"
