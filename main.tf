# Elasticsearch domain
resource "aws_elasticsearch_domain" "es" {
  domain_name = "tf-${var.domain_name}"
  elasticsearch_version = "${var.es_version}"
  cluster_config {
    instance_type = "${var.instance_type}"
    instance_count = "${var.instance_count}"
    dedicated_master_enabled = "${var.instance_count >= 10 ? true : false}"
    dedicated_master_count = 3
    dedicated_master_type = "${var.dedicated_master_type ? var.dedicated_master_type : var.instance_type}"
  }

  advanced_options {
  }

  access_policies = 

  snapshot_options {
  }

  tags {
    Domain = "${var.domain_name}"
  }

}

# Management instance with Elastic IP

/* vim: set et fenc= ff=unix ft=terraform sts=2 sw=2 ts=2 : */
