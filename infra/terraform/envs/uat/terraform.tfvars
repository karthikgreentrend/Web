# =============================================================================
# UAT Environment Configuration
# Branch: release/* -> Environment: uat
# URL: https://uat.karthik.uk
# =============================================================================

environment = "uat"
git_branch  = "release"

# AWS Region
aws_region = "us-east-1"

# Project
project_name = "greentrend"

# Domain Configuration - YOUR DOMAIN
domain_name        = "karthik.uk"
create_hosted_zone = false  # Use the same hosted zone created in dev
hosted_zone_id     = ""     # Will be populated after initial deployment

# VPC Configuration
vpc_cidr           = "10.1.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]

# Application
app_port          = 3000
health_check_path = "/health"

# Features
enable_s3_hosting  = true
enable_cloudfront  = true
create_certificate = false  # Reuse wildcard certificate from dev

# CloudFront
cloudfront_price_class = "PriceClass_100"
