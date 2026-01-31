# =============================================================================
# DEV Environment Configuration
# Branch: develop -> Environment: dev
# URL: https://dev.karthik.uk
# =============================================================================

environment = "dev"
git_branch  = "develop"

# AWS Region
aws_region = "us-east-1"

# Project
project_name = "greentrend"

# Domain Configuration - YOUR DOMAIN
domain_name        = "karthik.uk"
create_hosted_zone = true   # Set to true to create Route53 hosted zone
hosted_zone_id     = ""     # Leave empty if creating new zone, or provide existing zone ID

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
