data "aws_iam_policy_document" "es_management_access" {
  count = "${!local.inside_vpc ? 1 : 0}"

  statement {
    actions = [
      "es:*",
    ]

    resources = [
      "${aws_elasticsearch_domain.es.arn}",
      "${aws_elasticsearch_domain.es.arn}/*",
    ]

    principals {
      type = "AWS"

      identifiers = ["${distinct(compact(var.management_iam_roles))}"]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = ["${distinct(compact(var.management_public_ip_addresses))}"]
    }
  }
}

data "aws_iam_policy" "cognito_access" {
  count = "${var.cognito_role_arn == "" ? 1 : 0}"
  arn   = "arn:aws:iam::aws:policy/AmazonESCognitoAccess"
}

resource "aws_iam_role" "cognito_access" {
  count = "${var.cognito_role_arn == "" ? 1 : 0}"
  name  = "CognitoAccessForAmazonES"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cognito_role_attachment" {
  count      = "${var.cognito_role_arn == "" ? 1 : 0}"
  role       = "${aws_iam_role.cognito_access.name}"
  policy_arn = "${data.aws_iam_policy.cognito_access.arn}"
}

resource "aws_elasticsearch_domain" "es" {
  count = "${!local.inside_vpc ? 1 : 0}"

  depends_on = ["aws_iam_service_linked_role.es"]

  domain_name           = "${local.domain_name}"
  elasticsearch_version = "${var.es_version}"

  encrypt_at_rest = {
    enabled    = "${var.encrypt_at_rest}"
    kms_key_id = "${var.kms_key_id}"
  }

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    dedicated_master_enabled = "${var.instance_count >= var.dedicated_master_threshold ? true : false}"
    dedicated_master_count   = "${var.instance_count >= var.dedicated_master_threshold ? 3 : 0}"
    dedicated_master_type    = "${var.instance_count >= var.dedicated_master_threshold ? (var.dedicated_master_type != "false" ? var.dedicated_master_type : var.instance_type) : ""}"
    zone_awareness_enabled   = "${var.es_zone_awareness}"
  }

  advanced_options = "${var.advanced_options}"

  log_publishing_options = "${var.log_publishing_options}"

  node_to_node_encryption {
    enabled = "${var.node_to_node_encryption_enabled}"
  }

  ebs_options {
    ebs_enabled = "${var.ebs_volume_size > 0 ? true : false}"
    volume_size = "${var.ebs_volume_size}"
    volume_type = "${var.ebs_volume_type}"
  }

  snapshot_options {
    automated_snapshot_start_hour = "${var.snapshot_start_hour}"
  }

  cognito_options {
    enabled          = "${local.enable_cognito}"
    user_pool_id     = "${var.cognito_user_pool_id}"
    identity_pool_id = "${var.cognito_identity_pool_id}"
    role_arn         = "${var.cognito_role_arn == "" ? aws_iam_role.cognito_access.arn : var.cognito_role_arn}"
  }

  tags = "${merge(map("Domain", local.domain_name), var.tags)}"
}

resource "aws_elasticsearch_domain_policy" "es_management_access" {
  count = "${!local.inside_vpc ? 1 : 0}"

  domain_name     = "${local.domain_name}"
  access_policies = "${data.aws_iam_policy_document.es_management_access.json}"
}
