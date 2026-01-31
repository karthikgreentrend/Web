# =============================================================================
# DEV Environment Configuration
# Branch: develop -> Environment: dev
# =============================================================================

environment = "dev"
git_branch  = "develop"

# AWS Region
aws_region = "us-east-1"

# Project
project_name = "web-app"

# Domain Configuration
domain_name        = "example.com"  # Replace with your domain
create_hosted_zone = false           # Set to true if you need to create a new zone
hosted_zone_id     = ""              # Provide existing zone ID if create_hosted_zone is false

# VPC Configuration
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# Application
app_port          = 3000
health_check_path = "/health"

# Features
enable_s3_hosting  = true
enable_cloudfront  = true
create_certificate = true

# CloudFront
cloudfront_price_class = "PriceClass_100"
