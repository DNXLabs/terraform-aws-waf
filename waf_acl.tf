resource "aws_waf_web_acl" "waf_acl" {
  count       = var.options.enable ? 1 : 0
  depends_on  = ["aws_waf_rule.sql_injection_rule", "aws_waf_rule.xss_rule"]
  name        = "CloudFrontGlobalWafWebAcl"
  metric_name = "cloudFrontGlobalWafWebAcl"

  default_action {
    type = "ALLOW"
  }

  dynamic "rules" {
    for_each = var.options.enable && var.options.sql_injection ? [var.options] : []
    content {
      action {
        type = "BLOCK"
      }

      priority = 1
      rule_id  = aws_waf_rule.sql_injection_rule[count.index].id
      type     = "REGULAR"
    }
  }

  dynamic "rules" {
    for_each = var.options.enable && var.options.sql_injection ? [var.options] : []
    content {
      action {
        type = "BLOCK"
      }

      priority = 1
      rule_id  = aws_waf_rule.xss_rule[count.index].id
      type     = "REGULAR"
    }
  }

  dynamic "rules" {
    for_each = var.options.enable && var.options.ip_blacklist.enable ? [var.options] : []
    content {
      action {
        type = "BLOCK"
      }

      priority = 1
      rule_id  = aws_waf_ipset.ip_set[count.index].id
      type     = "REGULAR"
    }
  }
}
