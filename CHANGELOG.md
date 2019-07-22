<a name="unreleased"></a>
## [Unreleased]



<a name="v0.8.0"></a>
## [v0.8.0] - 2019-03-08

- Updated release makefile
- Allow to create IAM service linked role conditionally
- Updated changelog


<a name="v0.7.0"></a>
## [v0.7.0] - 2019-02-17

- Updated changelog
- Merge pull request [#22](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/22) from terraform-community-modules/few_improvements
- Added support for the remaining arguments and attributes, including logging and auto-updated documentation. Fixes [#20](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/20), [#21](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/21), [#15](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/15).
- Merge pull request [#19](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/19) from yo61/add_changelog
- Support creation of CHANGELOG


<a name="v0.6.0"></a>
## [v0.6.0] - 2019-01-31

- Merge pull request [#18](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/18) from yo61/small_cluster_dedicated_masters
- Optionally set threshold for dedicated master nodes


<a name="v0.5.0"></a>
## [v0.5.0] - 2019-01-08

- Updated pre-commit hooks
- Merge pull request [#17](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/17) from yo61/make_prefix_optional
- Make prefix optional


<a name="v0.4.0"></a>
## [v0.4.0] - 2018-10-06

- Updated styles
- Merge pull request [#12](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/12) from Agrium/DO-506/use-cms-key
- DO-506: Passed in kms key


<a name="v0.3.0"></a>
## [v0.3.0] - 2018-08-19

- Merge pull request [#9](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/9) from dannybrody/master
- adding option to have encryption at rest inside a vpc


<a name="v0.2.0"></a>
## [v0.2.0] - 2018-08-19

- Added pre-commit hooks
- Merge pull request [#11](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/11) from perryao/master
- add variable for setting tags


<a name="v0.1.0"></a>
## [v0.1.0] - 2018-01-05

- docs: updating README to add new author
- VPC support ([#5](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/5))
- Merge pull request [#3](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/3) from kamilboratynski/bugfix/documentation
- Fixed description for `instance_count` variable


<a name="0.0.2"></a>
## [0.0.2] - 2017-05-30

- updating README for new release
- Merge pull request [#1](https://github.com/terraform-community-modules/tf_aws_elasticsearch/issues/1) from terraform-community-modules/strtobool_error
- undid two inadvertent changes
- fixing string that can't be parsed as boolean
- wrote README, ready for release
- add management_iam_roles parameter
- explicitly add all AWS principals
- more conditional magic to try to reduce churn
- argh, dependency cycle
- additional access control rule
- don't make a separate access_policies resource
- wrote some outputs
- typo fix
- attach access policies to es domain
- typo fix, wrong variable name
- first try at elasticsearch module
- building Elasticsearch domain
- initial commit
- Initial commit


<a name="0.0.1"></a>
## 0.0.1 - 2017-05-19

- wrote README, ready for release
- add management_iam_roles parameter
- explicitly add all AWS principals
- more conditional magic to try to reduce churn
- argh, dependency cycle
- additional access control rule
- don't make a separate access_policies resource
- wrote some outputs
- typo fix
- attach access policies to es domain
- typo fix, wrong variable name
- first try at elasticsearch module
- building Elasticsearch domain
- initial commit


[Unreleased]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/v0.8.0...HEAD
[v0.8.0]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/v0.7.0...v0.8.0
[v0.7.0]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/v0.6.0...v0.7.0
[v0.6.0]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/v0.5.0...v0.6.0
[v0.5.0]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/0.0.2...v0.1.0
[0.0.2]: https://github.com/terraform-community-modules/tf_aws_elasticsearch/compare/0.0.1...0.0.2
