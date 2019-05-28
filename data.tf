locals {
  domain_name    = "${var.use_prefix ? join("", list(var.domain_prefix, var.domain_name)) : var.domain_name}"
  inside_vpc     = "${length(var.vpc_options["subnet_ids"]) > 0 ? 1 : 0}"
  enable_cognito = "${var.cognito_user_pool_id != "" && var.cognito_user_pool_id != ""}"
}
