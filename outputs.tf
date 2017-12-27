output "arn" {
  description = "Amazon Resource Name (ARN) of the domain"
  value       = "${local.es_arn}"
}

output "domain_id" {
  description = "Unique identifier for the domain"
  value       = "${local.es_domain_id}"
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = "${local.es_endpoint}"
}

/* vim: set et fenc= ff=unix ft=terraform sts=2 sw=2 ts=2 : */

