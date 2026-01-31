# =============================================================================
# Route 53 Module - Outputs
# =============================================================================

output "hosted_zone_id" {
  description = "Hosted zone ID"
  value       = local.zone_id
}

output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : []
}

output "app_domain" {
  description = "Application domain name"
  value       = local.app_domain
}

output "app_record_fqdn" {
  description = "FQDN of the application A record"
  value       = length(aws_route53_record.app_alias) > 0 ? aws_route53_record.app_alias[0].fqdn : null
}
