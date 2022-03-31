locals {
  wafv2_managed_rule_groups       = [for i, v in var.wafv2_managed_rule_groups : { "name" : v, "type" : "managed" }]
  wafv2_managed_block_rule_groups = [for i, v in var.wafv2_managed_block_rule_groups : { "name" : v, "type" : "managed_block" }]
  wafv2_rate_limit_rule = var.wafv2_rate_limit_rule == 0 ? [] : [{
    "name" : "limit"
    "type" : "rate"
    "value" : var.wafv2_rate_limit_rule
  }]
  wafv2_rules = concat(local.wafv2_rate_limit_rule, local.wafv2_managed_block_rule_groups, local.wafv2_managed_rule_groups)
}