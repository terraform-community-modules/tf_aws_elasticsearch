# Elasticsearch domain
data "aws_iam_policy_document" "es_management_instance_access" {
  statement {
    actions = [
      "es:*",
    ]

    resources = [
      "${aws_elasticsearch_domain.es.arn}",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = ["${distinct(compact(var.management_public_ip_addresses))}"]
    }
  }
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = "tf-${var.domain_name}"
  elasticsearch_version = "${var.es_version}"

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    dedicated_master_enabled = "${var.instance_count >= 10 ? true : false}"
    dedicated_master_count   = 3
    dedicated_master_type    = "${var.dedicated_master_type ? var.dedicated_master_type : var.instance_type}"
    zone_awareness_enabled   = "${var.es_zone_awareness}"
  }

  # advanced_options {
  # }

  ebs_options {
    ebs_enabled = "${var.ebs_volume_size > 0 ? true : false}"
    volume_size = "${var.ebs_volume_size}"
    volume_type = "${var.ebs_volume_type}"
  }
  snapshot_options {
    automated_snapshot_start_hour = "${var.snapshot_start_hour}"
  }
  tags {
    Domain = "${var.domain_name}"
  }
}

# vim: set et fenc= ff=unix ft=terraform sts=2 sw=2 ts=2 : 
