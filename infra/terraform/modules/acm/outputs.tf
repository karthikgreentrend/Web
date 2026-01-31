# =============================================================================
# ACM Certificate Module - Outputs
# =============================================================================

output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = local.certificate_arn
}

output "certificate_domain_name" {
  description = "Certificate domain name"
  value       = var.create_certificate ? aws_acm_certificate.main[0].domain_name : null
}

output "certificate_status" {
  description = "Certificate status"
  value       = var.create_certificate ? aws_acm_certificate.main[0].status : "IMPORTED"
}
