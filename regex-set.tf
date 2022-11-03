resource "aws_wafv2_regex_pattern_set" "regex_set" {
  for_each = { for rule in try(var.regex_pattern_set_reference_statement_rules, []) : rule.name => rule }

  name  = "waf-regex-${var.global_rule}"
  scope = var.scope

  dynamic "regular_expression" {
    for_each = each.value.regex_set

    content {
      regex_string = regular_expression.value
    }
  }
}