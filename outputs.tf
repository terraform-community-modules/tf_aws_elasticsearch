output "arn" {
  description = "Amazon Resource Name (ARN) of the domain"
  value       = "${aws_elasticsearch_domain.es.arn}"
}

output "domain_id" {
  description = "Unique identifier for the domain"
  value       = "${aws_elasticsearch_domain.es.domain_id}"
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = "${aws_elasticsearch_domain.es.endpoint}"
}

/* vim: set et fenc= ff=unix ft=terraform sts=2 sw=2 ts=2 : */

