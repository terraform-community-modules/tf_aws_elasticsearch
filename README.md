# tf_aws_elasticsearch

Terraform module for deploying and managing [Amazon Elasticsearch Service](https://aws.amazon.com/documentation/elasticsearch-service/).

This module has two options for creating an Elasticsearch domain:
  1) Create an Elasticsearch domain with a public endpoint. Access policy is then based on the intersection of the following two criteria
     * source IP address
     * client IAM role

     See [this Stack Overflow post](http://stackoverflow.com/questions/32978026/proper-access-policy-for-amazon-elastic-search-cluster) for further discussion of access policies for Elasticsearch.
  2) Create an Elasticsearch domain and join it to a VPC. Access policy is then based on the intersection of the following two criteria:
     * security groups applied to Elasticsearch domain
     * client IAM role

If `vpc_options` option is set, Elasticsearch domain is created within a VPC. If not, Elasticsearch domain is created with a public endpoint

NOTE: **You can either launch your domain within a VPC or use a public endpoint, but you can't do both.** Considering this, adding or removing `vpc_options` will force **DESTRUCTION** of the old Elasticsearch domain and **CREATION** of a new one. More INFO - [VPC support](http://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-vpc.html)

Several options affect the resilience and scalability of your Elasticsearch domain.  For a production deployment:

- set `instance_count` to an even number (default: `6`) greater than or equal to the `dedicated_master_threshold` (default: `10`)
- choose an `instance_type` that is not in the T2 family
- set `es_zone_awareness` to `true`.

This will result in a cluster with three dedicated master nodes, balanced across two availability zones.

For a production deployment it may also make sense to use EBS volumes rather that instance storage; to do so, set `ebs_volume_size` greater than 0 and optionally specify a value for `ebs_volume_type` (right now the only supported values are `gp2` and `magnetic`).


## Terraform versions

Terraform 0.12. Pin module version to `~> v1.0`. Submit pull-requests to `master` branch.

Terraform 0.11. Pin module version to `~> v0.0`. Submit pull-requests to `terraform011` branch.

# Usage

Create Elasticsearch domain with public endpoint

```hcl
module "es" {
  source  = "git::https://github.com/terraform-community-modules/tf_aws_elasticsearch.git?ref=v1.1.0"

  domain_name                    = "my-elasticsearch-domain"
  management_public_ip_addresses = ["34.203.XXX.YYY"]
  instance_count                 = 16
  instance_type                  = "m4.2xlarge.elasticsearch"
  dedicated_master_type          = "m4.large.elasticsearch"
  es_zone_awareness              = true
  ebs_volume_size                = 100
}
```

Create Elasticsearch domain within a VPC and CloudWatch logs

```hcl
module "es" {
  source  = "git::https://github.com/terraform-community-modules/tf_aws_elasticsearch.git?ref=v1.1.0"

  domain_name                    = "my-elasticsearch-domain"
  vpc_options                    = {
    security_group_ids = ["sg-XXXXXXXX"]
    subnet_ids         = ["subnet-YYYYYYYY"]
  }
  instance_count                 = 1
  instance_type                  = "t2.medium.elasticsearch"
  dedicated_master_type          = "t2.medium.elasticsearch"
  es_zone_awareness              = false
  ebs_volume_size                = 35
  
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"   # double quotes are required here
  }

  log_publishing_options = [
    {
      cloudwatch_log_group_arn = "arn:aws:logs:eu-central-1:604506250243:log-group:es:*"
      log_type                 = "INDEX_SLOW_LOGS"
      enabled                  = true
    },
    {
      cloudwatch_log_group_arn = "arn:aws:logs:eu-central-1:604506250243:log-group:es:*"
      log_type                 = "SEARCH_SLOW_LOGS"
      enabled                  = true
    },
    {
      cloudwatch_log_group_arn = "arn:aws:logs:eu-central-1:604506250243:log-group:es:*"
      log_type                 = "ES_APPLICATION_LOGS"
      enabled                  = true
    }
  ]
}
```

Create small (4-node) Elasticsearch domain in a VPC with dedicated master nodes

```hcl
module "es" {
  source  = "git::https://github.com/terraform-community-modules/tf_aws_elasticsearch.git?ref=v1.1.0"

  domain_name                    = "my-elasticsearch-domain"
  vpc_options                    = {
    security_group_ids = ["sg-XXXXXXXX"]
    subnet_ids         = ["subnet-YYYYYYYY"]
  }
  instance_count                 = 4
  instance_type                  = "m4.2xlarge.elasticsearch"
  dedicated_master_threshold     = 4
  dedicated_master_type          = "m4.large.elasticsearch"
  es_zone_awareness              = true
  ebs_volume_size                = 100
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticsearch_domain.es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_elasticsearch_domain.es_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_elasticsearch_domain_policy.es_management_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain_policy) | resource |
| [aws_elasticsearch_domain_policy.es_vpc_management_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain_policy) | resource |
| [aws_iam_service_linked_role.es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.es_management_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.es_vpc_management_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_advanced_options"></a> [advanced\_options](#input\_advanced\_options) | Map of key-value string pairs to specify advanced configuration options. Note that the values for these configuration options must be strings (wrapped in quotes) or they may be wrong and cause a perpetual diff, causing Terraform to want to recreate your Elasticsearch domain on every apply. | `map(string)` | `{}` | no |
| <a name="input_advanced_security_options_enabled"></a> [advanced\_security\_options\_enabled](#input\_advanced\_security\_options\_enabled) | Whether advanced security is enabled. | `bool` | `true` | no |
| <a name="input_advanced_security_options_internal_user_database_enabled"></a> [advanced\_security\_options\_internal\_user\_database\_enabled](#input\_advanced\_security\_options\_internal\_user\_database\_enabled) | Whether to enable or not internal Kibana user database for ELK OpenDistro security plugin | `bool` | `false` | no |
| <a name="input_advanced_security_options_master_user_name"></a> [advanced\_security\_options\_master\_user\_name](#input\_advanced\_security\_options\_master\_user\_name) | Master user username (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to true) | `string` | `null` | no |
| <a name="input_advanced_security_options_master_user_password"></a> [advanced\_security\_options\_master\_user\_password](#input\_advanced\_security\_options\_master\_user\_password) | Master user password (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to true) | `string` | `null` | no |
| <a name="input_create_iam_service_linked_role"></a> [create\_iam\_service\_linked\_role](#input\_create\_iam\_service\_linked\_role) | Whether to create IAM service linked role for AWS ElasticSearch service. Can be only one per AWS account. | `bool` | `true` | no |
| <a name="input_dedicated_master_threshold"></a> [dedicated\_master\_threshold](#input\_dedicated\_master\_threshold) | The number of instances above which dedicated master nodes will be used. Default: 10 | `number` | `10` | no |
| <a name="input_dedicated_master_type"></a> [dedicated\_master\_type](#input\_dedicated\_master\_type) | ES instance type to be used for dedicated masters (default same as instance\_type) | `string` | `"false"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for Elasticsearch cluster | `string` | `"es-domain"` | no |
| <a name="input_domain_prefix"></a> [domain\_prefix](#input\_domain\_prefix) | String to be prefixed to search domain. Default: tf- | `string` | `"tf-"` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | Optionally use EBS volumes for data storage by specifying volume size in GB (default 0) | `number` | `0` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | Storage type of EBS volumes, if used (default gp2) | `string` | `"gp2"` | no |
| <a name="input_encrypt_at_rest"></a> [encrypt\_at\_rest](#input\_encrypt\_at\_rest) | Enable encrption at rest (only specific instance family types support it: m4, c4, r4, i2, i3 default: false) | `bool` | `false` | no |
| <a name="input_enforce_https"></a> [enforce\_https](#input\_enforce\_https) | Whether or not to require HTTPS. | `bool` | `false` | no |
| <a name="input_es_version"></a> [es\_version](#input\_es\_version) | Version of Elasticsearch to deploy (default 5.1) | `string` | `"5.1"` | no |
| <a name="input_es_zone_awareness"></a> [es\_zone\_awareness](#input\_es\_zone\_awareness) | Enable zone awareness for Elasticsearch cluster (default false) | `bool` | `false` | no |
| <a name="input_es_zone_awareness_count"></a> [es\_zone\_awareness\_count](#input\_es\_zone\_awareness\_count) | Number of availability zones used for data nodes (default 2) | `number` | `2` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of data nodes in the cluster (default 6) | `number` | `6` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | ES instance type for data nodes in the cluster (default t2.small.elasticsearch) | `string` | `"t2.small.elasticsearch"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key used for elasticsearch | `string` | `""` | no |
| <a name="input_log_publishing_options"></a> [log\_publishing\_options](#input\_log\_publishing\_options) | List of maps of options for publishing slow logs to CloudWatch Logs. | `list(map(string))` | `[]` | no |
| <a name="input_management_iam_roles"></a> [management\_iam\_roles](#input\_management\_iam\_roles) | List of IAM role ARNs from which to permit management traffic (default ['*']).  Note that a client must match both the IP address and the IAM role patterns in order to be permitted access. | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_management_public_ip_addresses"></a> [management\_public\_ip\_addresses](#input\_management\_public\_ip\_addresses) | List of IP addresses from which to permit management traffic (default []).  Note that a client must match both the IP address and the IAM role patterns in order to be permitted access. | `list(string)` | `[]` | no |
| <a name="input_master_user_arn"></a> [master\_user\_arn](#input\_master\_user\_arn) | The ARN for the master user of the cluster. If not specified, then it defaults to using the IAM user that is making the request. | `string` | `""` | no |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Whether to enable node-to-node encryption. | `bool` | `false` | no |
| <a name="input_snapshot_start_hour"></a> [snapshot\_start\_hour](#input\_snapshot\_start\_hour) | Hour at which automated snapshots are taken, in UTC (default 0) | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_tls_security_policy"></a> [tls\_security\_policy](#input\_tls\_security\_policy) | The name of the TLS security policy that needs to be applied to the HTTPS endpoint. Example values: Policy-Min-TLS-1-0-2019-07 and Policy-Min-TLS-1-2-2019-07. Terraform will only perform drift detection if a configuration value is provided. | `string` | `null` | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Flag indicating whether or not to use the domain\_prefix. Default: true | `bool` | `true` | no |
| <a name="input_vpc_options"></a> [vpc\_options](#input\_vpc\_options) | A map of supported vpc options | `map(list(string))` | <pre>{<br>  "security_group_ids": [],<br>  "subnet_ids": []<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name (ARN) of the domain |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | Unique identifier for the domain |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The name of the Elasticsearch domain |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Domain-specific endpoint used to submit index, search, and data upload requests |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | Domain-specific endpoint for kibana without https scheme |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Originally created by [Steve Huff](https://github.com/hakamadare), [Alexander Gramovich](https://github.com/ggramal) and [these awesome contributors](https://github.com/terraform-community-modules/tf_aws_elasticsearch/graphs/contributors).

Module managed by [Anton Babenko](https://github.com/antonbabenko).

## License

MIT licensed. See `LICENSE.md` for full details.
