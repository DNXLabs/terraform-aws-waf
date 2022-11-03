resource "aws_wafv2_ip_set" "ip_set" {
  for_each = { for rule in try(var.ip_set_reference_statement_rules, []) : rule.name => rule }

  name               = "waf-ipset-${var.global_rule}"
  ip_address_version = "IPV4"
  addresses          = each.value.ip_set
  scope              = var.scope
}