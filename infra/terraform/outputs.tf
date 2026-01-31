# =============================================================================
# Outputs Configuration
# =============================================================================

# -----------------------------------------------------------------------------
# General Outputs
# -----------------------------------------------------------------------------

output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "aws_region" {
  description = "AWS region"
  value       = local.region
}

output "account_id" {
  description = "AWS account ID"
  value       = local.account_id
}

# -----------------------------------------------------------------------------
# Route 53 Outputs
# -----------------------------------------------------------------------------

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID"
  value       = module.route53.hosted_zone_id
}

output "hosted_zone_name_servers" {
  description = "Route 53 hosted zone name servers"
  value       = module.route53.name_servers
}

output "app_domain" {
  description = "Application domain name"
  value       = module.route53.app_domain
}

# -----------------------------------------------------------------------------
# VPC Outputs
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# -----------------------------------------------------------------------------
# S3 Outputs
# -----------------------------------------------------------------------------

output "s3_bucket_name" {
  description = "S3 bucket name for hosting"
  value       = var.enable_s3_hosting ? module.s3[0].bucket_name : null
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = var.enable_s3_hosting ? module.s3[0].bucket_arn : null
}

output "s3_website_endpoint" {
  description = "S3 website endpoint"
  value       = var.enable_s3_hosting ? module.s3[0].website_endpoint : null
}

# -----------------------------------------------------------------------------
# CloudFront Outputs
# -----------------------------------------------------------------------------

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = var.enable_cloudfront ? module.cloudfront[0].distribution_id : null
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = var.enable_cloudfront ? module.cloudfront[0].domain_name : null
}

# -----------------------------------------------------------------------------
# ACM Outputs
# -----------------------------------------------------------------------------

output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = module.acm.certificate_arn
}

# -----------------------------------------------------------------------------
# S3 Artifacts Outputs (Security Reports)
# -----------------------------------------------------------------------------

output "artifacts_bucket_name" {
  description = "S3 bucket name for security artifacts"
  value       = module.s3_artifacts.bucket_name
}

output "artifacts_bucket_arn" {
  description = "S3 bucket ARN for security artifacts"
  value       = module.s3_artifacts.bucket_arn
}
