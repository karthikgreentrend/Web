# =============================================================================
# ACM Certificate Module - Variables
# =============================================================================

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Primary domain name for the certificate"
  type        = string
}

variable "create_certificate" {
  description = "Whether to create a new certificate"
  type        = bool
  default     = true
}

variable "certificate_arn" {
  description = "Existing certificate ARN"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Hosted zone ID for DNS validation"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
