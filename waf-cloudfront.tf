resource "aws_wafv2_web_acl" "waf_cloudfront" {
  count       = var.waf_cloudfront_enable ? 1 : 0
  name        = "waf-${var.global_rule}"
  description = "WAF managed rules for Cloudfront"
  scope       = var.scope

  default_action {
    allow {}
  }

  dynamic "rule" {


    for_each = local.wafv2_rules

    content {
      name     = "waf-${var.global_rule}-${rule.value.type}-${rule.value.name}"
      priority = rule.key

      dynamic "override_action" {
        for_each = rule.value.type == "managed" ? [1] : []
        content {
          count {}
        }
      }

      dynamic "action" {
        for_each = rule.value.type == "rate" ? [1] : []
        content {
          block {}
        }
      }

      statement {
        dynamic "rate_based_statement" {
          for_each = rule.value.type == "rate" ? [1] : []
          content {
            limit              = rule.value.value
            aggregate_key_type = "IP"
          }
        }

        dynamic "managed_rule_group_statement" {
          for_each = rule.value.type == "managed" || rule.value.type == "managed_block" ? [1] : []
          content {
            name        = rule.value.name
            vendor_name = "AWS"
          }
        }
      }


      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-${rule.value.type}-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }

  tags = {
    Name = "waf-cloudfront-${var.global_rule}-static-application"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-cloudfront-${var.global_rule}-general"
    sampled_requests_enabled   = true
  }

}
