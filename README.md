# tf_aws_elasticsearch

Terraform module for deploying and managing [Amazon Elasticsearch Service](https://aws.amazon.com/documentation/elasticsearch-service/).

This module has two options for creating an Elasticsearch domain:
  1) Create an Elasticsearch domain with a public endpoint. Access policy is then based on the intersection of the following two criteria
     * source IP address
     * client IAM role

     See [this Stack Overflow post](http://stackoverflow.com/questions/32978026/proper-access-policy-for-amazon-elastic-search-cluster) for further discussion of access policies for Elasticsearch.
  2) Create an Elasticsearch domain and join it to a VPC. Access policy is then based on he intersection of the following two criteria:
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


## Usage

Create Elasticsearch domain with public endpoint

```hcl
module "es" {
  source                         = "github.com/terraform-community-modules/tf_aws_elasticsearch"
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
  source                         = "github.com/terraform-community-modules/tf_aws_elasticsearch"
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
  source                         = "github.com/terraform-community-modules/tf_aws_elasticsearch"
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
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| advanced\_options | Map of key-value string pairs to specify advanced configuration options. Note that the values for these configuration options must be strings (wrapped in quotes) or they may be wrong and cause a perpetual diff, causing Terraform to want to recreate your Elasticsearch domain on every apply. | map | `{}` | no |
| create\_iam\_service\_linked\_role | Whether to create IAM service linked role for AWS ElasticSearch service. Can be only one per AWS account. | string | `"true"` | no |
| dedicated\_master\_threshold | The number of instances above which dedicated master nodes will be used. Default: 10 | string | `"10"` | no |
| dedicated\_master\_type | ES instance type to be used for dedicated masters (default same as instance_type) | string | `"false"` | no |
| domain\_name | Domain name for Elasticsearch cluster | string | `"es-domain"` | no |
| domain\_prefix | String to be prefixed to search domain. Default: tf- | string | `"tf-"` | no |
| ebs\_volume\_size | Optionally use EBS volumes for data storage by specifying volume size in GB (default 0) | string | `"0"` | no |
| ebs\_volume\_type | Storage type of EBS volumes, if used (default gp2) | string | `"gp2"` | no |
| encrypt\_at\_rest | Enable encrption at rest (only specific instance family types support it: m4, c4, r4, i2, i3 default: false) | string | `"false"` | no |
| es\_version | Version of Elasticsearch to deploy (default 5.1) | string | `"5.1"` | no |
| es\_zone\_awareness | Enable zone awareness for Elasticsearch cluster (default false) | string | `"false"` | no |
| instance\_count | Number of data nodes in the cluster (default 6) | string | `"6"` | no |
| instance\_type | ES instance type for data nodes in the cluster (default t2.small.elasticsearch) | string | `"t2.small.elasticsearch"` | no |
| kms\_key\_id | KMS key used for elasticsearch | string | `""` | no |
| log\_publishing\_options | List of maps of options for publishing slow logs to CloudWatch Logs. | list | `[]` | no |
| management\_iam\_roles | List of IAM role ARNs from which to permit management traffic (default ['*']).  Note that a client must match both the IP address and the IAM role patterns in order to be permitted access. | list | `[ "*" ]` | no |
| management\_public\_ip\_addresses | List of IP addresses from which to permit management traffic (default []).  Note that a client must match both the IP address and the IAM role patterns in order to be permitted access. | list | `[]` | no |
| node\_to\_node\_encryption\_enabled | Whether to enable node-to-node encryption. | string | `"false"` | no |
| snapshot\_start\_hour | Hour at which automated snapshots are taken, in UTC (default 0) | string | `"0"` | no |
| tags | tags to apply to all resources | map | `{}` | no |
| use\_prefix | Flag indicating whether or not to use the domain_prefix. Default: true | string | `"true"` | no |
| vpc\_options | A map of supported vpc options | map | `{ "security_group_ids": [], "subnet_ids": [] }` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of the domain |
| domain\_id | Unique identifier for the domain |
| domain\_name | The name of the Elasticsearch domain |
| endpoint | Domain-specific endpoint used to submit index, search, and data upload requests |
| kibana\_endpoint | Domain-specific endpoint for kibana without https scheme |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Originally created by [Steve Huff](https://github.com/hakamadare), [Alexander Gramovich](https://github.com/ggramal) and [these awesome contributors](https://github.com/terraform-community-modules/tf_aws_elasticsearch/graphs/contributors).

Module managed by [Anton Babenko](https://github.com/antonbabenko).

## License

MIT licensed. See `LICENSE.md` for full details.
