# =============================================================================
# Main Terraform Configuration
# GitFlow Deployment Strategy: main->prod, develop->dev, release->uat
# =============================================================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration - will be configured per environment
  backend "s3" {}
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      GitBranch   = var.git_branch
    }
  }
}

# =============================================================================
# Data Sources
# =============================================================================

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# =============================================================================
# Local Values
# =============================================================================

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # Environment-specific naming
  name_prefix = "${var.project_name}-${var.environment}"

  # Application domain (used for DNS records)
  app_domain = var.environment == "prod" ? var.domain_name : "${var.environment}.${var.domain_name}"

  # Common tags
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
