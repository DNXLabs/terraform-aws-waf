module "terraform_aws_wafv2_regional" {
  source   = "git::https://github.com/DNXLabs/terraform-aws-waf.git?ref=1.1.0"
  for_each = { for rule in try(local.workspace.wafv2_regional.rules, []) : rule.regional_rule => rule }

  waf_regional_enable = try(each.value.waf_regional_enable, false)
  associate_waf       = try(each.value.associate_waf, false)
  regional_rule       = try(each.value.regional_rule, [])
  scope               = each.value.scope
  resource_arn        = try(each.value.resource_arn, [])
  default_action      = try(each.value.default_action, "block")

  ### Log Configuration
  logs_enable             = try(each.value.logs_enable, false)
  logs_retension          = try(each.value.logs_retension, 90)
  logging_redacted_fields = try(each.value.logging_redacted_fields, [])
  logging_filter          = try(each.value.logging_filter, [])

  ### Statement Rules
  byte_match_statement_rules                  = try(each.value.byte_match_statement_rules, [])
  geo_match_statement_rules                   = try(each.value.geo_match_statement_rules, [])
  ip_set_reference_statement_rules            = try(each.value.ip_set_reference_statement_rules, [])
  managed_rule_group_statement_rules          = try(each.value.managed_rule_group_statement_rules, [])
  rate_based_statement_rules                  = try(each.value.rate_based_statement_rules, [])
  regex_pattern_set_reference_statement_rules = try(each.value.regex_pattern_set_reference_statement_rules, [])
  size_constraint_statement_rules             = try(each.value.size_constraint_statement_rules, [])
  sqli_match_statement_rules                  = try(each.value.sqli_match_statement_rules, [])
  xss_match_statement_rules                   = try(each.value.xss_match_statement_rules, [])
}