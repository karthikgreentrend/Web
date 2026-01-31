# -----------------------------------------------------------------------------
# OpenSearch Variables
# -----------------------------------------------------------------------------

variable "opensearch_access_policies" {
  description = "Access policy JSON for OpenSearch domain"
  type        = string
  default     = ""
}
# =============================================================================
# Variables Configuration
# =============================================================================

# -----------------------------------------------------------------------------
# General Variables
# -----------------------------------------------------------------------------

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "web-app"
}

variable "environment" {
  description = "Environment name (dev, uat, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be one of: dev, uat, prod."
  }
}

variable "git_branch" {
  description = "Git branch name for tagging"
  type        = string
  default     = "main"
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# -----------------------------------------------------------------------------
# Route 53 Variables
# -----------------------------------------------------------------------------

variable "domain_name" {
  description = "Primary domain name for Route 53"
  type        = string
}

variable "create_hosted_zone" {
  description = "Whether to create a new hosted zone or use existing"
  type        = bool
  default     = false
}

variable "hosted_zone_id" {
  description = "Existing Route 53 hosted zone ID (required if create_hosted_zone is false)"
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# VPC Variables
# -----------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

# -----------------------------------------------------------------------------
# Application Variables
# -----------------------------------------------------------------------------

variable "app_port" {
  description = "Port on which the application runs"
  type        = number
  default     = 3000
}

variable "health_check_path" {
  description = "Health check path for the application"
  type        = string
  default     = "/health"
}

# -----------------------------------------------------------------------------
# S3 Variables (for static hosting if needed)
# -----------------------------------------------------------------------------

variable "enable_s3_hosting" {
  description = "Enable S3 static website hosting"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# CloudFront Variables
# -----------------------------------------------------------------------------

variable "enable_cloudfront" {
  description = "Enable CloudFront distribution"
  type        = bool
  default     = true
}

variable "cloudfront_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

# -----------------------------------------------------------------------------
# SSL/TLS Variables
# -----------------------------------------------------------------------------

variable "create_certificate" {
  description = "Whether to create ACM certificate"
  type        = bool
  default     = true
}

variable "certificate_arn" {
  description = "Existing ACM certificate ARN (required if create_certificate is false)"
  type        = string
  default     = ""
}

# -----------------------------------------------------------------------------
# Aurora Variables
# -----------------------------------------------------------------------------

variable "aurora_master_username" {
  description = "Aurora master username"
  type        = string
}

variable "aurora_master_password" {
  description = "Aurora master password"
  type        = string
  sensitive   = true
}

variable "aurora_database_name" {
  description = "Aurora initial database name"
  type        = string
}
