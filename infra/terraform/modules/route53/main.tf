# =============================================================================
# Route 53 Module - Main Configuration
# =============================================================================

# -----------------------------------------------------------------------------
# Hosted Zone (optional creation)
# -----------------------------------------------------------------------------

resource "aws_route53_zone" "main" {
  count = var.create_hosted_zone ? 1 : 0

  name    = var.domain_name
  comment = "${var.project_name} ${var.environment} hosted zone"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-zone"
  })
}

# -----------------------------------------------------------------------------
# Local Values
# -----------------------------------------------------------------------------

locals {
  zone_id = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : var.hosted_zone_id

  # Environment-specific subdomain
  subdomain = var.environment == "prod" ? "" : "${var.environment}."

  # Full domain for the application
  app_domain = var.environment == "prod" ? var.domain_name : "${var.environment}.${var.domain_name}"
}

# -----------------------------------------------------------------------------
# A Record - CloudFront Alias
# -----------------------------------------------------------------------------

resource "aws_route53_record" "app_alias" {
  count = var.cloudfront_domain_name != null ? 1 : 0

  zone_id = local.zone_id
  name    = local.app_domain
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# -----------------------------------------------------------------------------
# AAAA Record - CloudFront Alias (IPv6)
# -----------------------------------------------------------------------------

resource "aws_route53_record" "app_alias_ipv6" {
  count = var.cloudfront_domain_name != null ? 1 : 0

  zone_id = local.zone_id
  name    = local.app_domain
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# -----------------------------------------------------------------------------
# WWW Subdomain Record (for prod only)
# -----------------------------------------------------------------------------

resource "aws_route53_record" "www" {
  count = var.environment == "prod" && var.cloudfront_domain_name != null ? 1 : 0

  zone_id = local.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
