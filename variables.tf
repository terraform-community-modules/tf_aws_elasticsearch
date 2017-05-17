variable "domain_name" {
  description = "Domain name for Elasticsearch cluster (will be prefixed with 'tf-')"
  default = "es-domain"
}

variable "es_version" {
  description = "Version of Elasticsearch to deploy (default 5.1)"
  default = "5.1"
}

variable "instance_type" {
  description = "ES instance type for data nodes in the cluster (default t2.small.elasticsearch)"
  default = "t2.small.elasticsearch"
}

variable "instance_count" {
  description = "Number of data nodes in the cluster (default 3)"
  default = 6
}

variable "dedicated_master_type" {
  description = "ES instance type to be used for dedicated masters (default same as instance_type)"
  default = false
}

/* vim: set et fenc=utf-8 ff=unix ft=terraform sts=2 sw=2 ts=2 : */
