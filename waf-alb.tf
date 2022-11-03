resource "aws_wafv2_web_acl" "waf_regional" {
  count = var.waf_regional_enable ? 1 : 0

  name        = "waf-${var.regional_rule}"
  description = "Regional WAF managed rules"
  scope       = var.scope

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-cloudfront-${var.global_rule}-general"
    sampled_requests_enabled   = false
  }

  dynamic "rule" {

    for_each = { for rule in try(var.byte_match_statement_rules, []) : rule.name => rule }

    content {
      name     = "waf-${var.global_rule}-${rule.value.name}"
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []

          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []

          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []

          content {}
        }
      }

      statement {
        dynamic "byte_match_statement" {
          for_each = { for byte_match in try(rule.value.byte_matchs, []) : byte_match.search_string => byte_match }

          content {
            positional_constraint = byte_match_statement.value.positional_constraint
            search_string         = byte_match_statement.value.search_string

            dynamic "field_to_match" {
              for_each = rule.value.byte_match_statement

              content {
                dynamic "all_query_arguments" {
                  for_each = field_to_match.value.all_query_arguments != null ? [1] : []

                  content {}
                }

                dynamic "body" {
                  for_each = field_to_match.value.body != null ? [1] : []

                  content {}
                }

                dynamic "method" {
                  for_each = field_to_match.value.method != null ? [1] : []

                  content {}
                }

                dynamic "query_string" {
                  for_each = field_to_match.value.query_string != null ? [1] : []

                  content {}
                }
                dynamic "single_header" {
                  for_each = field_to_match.value.single_header != null ? [1] : []

                  content {
                    name = field_to_match.value.single_header
                  }
                }
                dynamic "single_query_argument" {
                  for_each = field_to_match.value.single_query_argument != null ? [1] : []

                  content {
                    name = field_to_match.value.single_query_argument
                  }
                }

                dynamic "uri_path" {
                  for_each = field_to_match.value.uri_path != null ? [1] : []

                  content {}
                }
              }
            }

            dynamic "text_transformation" {
              for_each = { for text_transformation_rule in try(rule.value.text_transformation, []) : text_transformation_rule.priority => text_transformation_rule }

              content {
                priority = text_transformation.value.priority
                type     = text_transformation.value.type
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {

    for_each = { for rule in try(var.geo_match_statement_rules, []) : rule.name => rule }

    content {
      name     = "waf-${var.global_rule}-${rule.value.name}"
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []

          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []

          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []

          content {}
        }
      }

      statement {
        geo_match_statement {
          country_codes = rule.value.country_codes
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-${rule.value.name}"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {

    for_each = { for rule in try(var.ip_set_reference_statement_rules, []) : rule.name => rule }

    content {
      name     = "waf-${var.global_rule}-${rule.value.name}"
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []

          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []

          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []

          content {}
        }
      }

      statement {
        dynamic "ip_set_reference_statement" {
          for_each = { for ip_set_reference_statement_rules in try(rule.value.ip_set_reference_statement, []) : ip_set_reference_statement_rules.fallback_behavior => ip_set_reference_statement_rules }

          content {
            arn = aws_wafv2_ip_set.ip_set[rule.value.name].arn

            ip_set_forwarded_ip_config {
              fallback_behavior = ip_set_reference_statement.value.fallback_behavior
              header_name       = ip_set_reference_statement.value.header_name
              position          = ip_set_reference_statement.value.position
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-${rule.value.name}"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {

    for_each = { for rule in try(var.managed_rule_group_statement_rules, []) : rule.name => rule }

    content {
      name     = "waf-${var.global_rule}-managed-${rule.value.name}"
      priority = rule.value.priority

      override_action {
        dynamic "count" {
          for_each = lookup(rule.value, "override_action", null) == "count" ? [1] : []
          content {}
        }
        dynamic "none" {
          for_each = lookup(rule.value, "override_action", null) != "count" ? [1] : []
          content {}
        }
      }

      statement {
        dynamic "managed_rule_group_statement" {
          for_each = { for managed_rule in try(rule.value.managed_rule_group_statement, []) : managed_rule.name => managed_rule }

          content {
            name        = managed_rule_group_statement.value.name
            vendor_name = managed_rule_group_statement.value.vendor_name

            dynamic "excluded_rule" {
              for_each = { for excluded_rule in try(managed_rule_group_statement.value.excluded_rule, []) : excluded_rule.name => excluded_rule }

              content {
                name = excluded_rule.value.name
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-managed-${rule.value.name}"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {

    for_each = { for rule in try(var.rate_based_statement_rules, []) : rule.name => rule }

    content {
      name     = "waf-${var.global_rule}-${rule.value.name}"
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []

          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []

          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []

          content {}
        }
      }

      statement {
        dynamic "rate_based_statement" {
          for_each = { for rate_based in try(rule.value.rate_based, []) : rate_based.aggregate_key_type => rate_based }

          content {
            aggregate_key_type = rate_based_statement.value.aggregate_key_type
            limit              = rate_based_statement.value.limit

            dynamic "forwarded_ip_config" {
              for_each = { for forwarded_ip_config_rule in try(rule.value.rate_based_statement, []) : forwarded_ip_config_rule.fallback_behavior => forwarded_ip_config_rule }

              content {
                fallback_behavior = forwarded_ip_config.value.fallback_behavior
                header_name       = forwarded_ip_config.value.header_name
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-${rule.value.name}"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {

    for_each = { for rule in try(var.regex_pattern_set_reference_statement_rules, []) : rule.name => rule }

    content {
      name     = "waf-${var.global_rule}-${rule.value.name}"
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []

          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []

          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []

          content {}
        }
      }

      statement {
        regex_pattern_set_reference_statement {
          arn = aws_wafv2_regex_pattern_set.regex_set[rule.value.name].arn

          dynamic "field_to_match" {
            for_each = rule.value.regex_pattern_set_reference_statement

            content {
              dynamic "all_query_arguments" {
                for_each = field_to_match.value.all_query_arguments != null ? [1] : []

                content {}
              }

              dynamic "body" {
                for_each = field_to_match.value.body != null ? [1] : []

                content {}
              }

              dynamic "method" {
                for_each = field_to_match.value.method != null ? [1] : []

                content {}
              }

              dynamic "query_string" {
                for_each = field_to_match.value.query_string != null ? [1] : []

                content {}
              }
              dynamic "single_header" {
                for_each = field_to_match.value.single_header != null ? [1] : []

                content {
                  name = field_to_match.value.single_header
                }
              }
              dynamic "single_query_argument" {
                for_each = field_to_match.value.single_query_argument != null ? [1] : []

                content {
                  name = field_to_match.value.single_query_argument
                }
              }

              dynamic "uri_path" {
                for_each = field_to_match.value.uri_path != null ? [1] : []

                content {}
              }
            }
          }

          dynamic "text_transformation" {
            for_each = { for text_transformation_rule in try(rule.value.text_transformation, []) : text_transformation_rule.priority => text_transformation_rule }

            content {
              priority = text_transformation.value.priority
              type     = text_transformation.value.type
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-${rule.value.name}"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {

    for_each = { for rule in try(var.size_constraint_statement_rules, []) : rule.name => rule }

    content {
      name     = "waf-${var.global_rule}-${rule.value.name}"
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []

          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []

          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []

          content {}
        }
      }

      statement {
        size_constraint_statement {
          comparison_operator = rule.value.comparison_operator
          size                = rule.value.size

          dynamic "field_to_match" {
            for_each = rule.value.size_constraint_statement

            content {
              dynamic "all_query_arguments" {
                for_each = field_to_match.value.all_query_arguments != null ? [1] : []

                content {}
              }

              dynamic "body" {
                for_each = field_to_match.value.body != null ? [1] : []

                content {}
              }

              dynamic "method" {
                for_each = field_to_match.value.method != null ? [1] : []

                content {}
              }

              dynamic "query_string" {
                for_each = field_to_match.value.query_string != null ? [1] : []

                content {}
              }

              dynamic "single_header" {
                for_each = field_to_match.value.single_header != null ? [1] : []

                content {
                  name = field_to_match.value.single_header
                }
              }
              dynamic "single_query_argument" {
                for_each = field_to_match.value.single_query_argument != null ? [1] : []

                content {
                  name = field_to_match.value.single_query_argument
                }
              }

              dynamic "uri_path" {
                for_each = field_to_match.value.uri_path != null ? [1] : []

                content {}
              }
            }
          }

          dynamic "text_transformation" {
            for_each = { for text_transformation_rule in try(rule.value.text_transformation, []) : text_transformation_rule.priority => text_transformation_rule }

            content {
              priority = text_transformation.value.priority
              type     = text_transformation.value.type
            }
          }
        }
      }


      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-${rule.value.name}"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {

    for_each = { for rule in try(var.sqli_match_statement_rules, []) : rule.name => rule }

    content {
      name     = "waf-${var.global_rule}-${rule.value.name}"
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []

          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []

          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []

          content {}
        }
      }

      statement {
        sqli_match_statement {

          dynamic "field_to_match" {
            for_each = rule.value.sqli_match_statement

            content {
              dynamic "all_query_arguments" {
                for_each = field_to_match.value.all_query_arguments != null ? [1] : []

                content {}
              }

              dynamic "body" {
                for_each = field_to_match.value.body != null ? [1] : []

                content {}
              }

              dynamic "method" {
                for_each = field_to_match.value.method != null ? [1] : []

                content {}
              }

              dynamic "query_string" {
                for_each = field_to_match.value.query_string != null ? [1] : []

                content {}
              }
              dynamic "single_header" {
                for_each = field_to_match.value.single_header != null ? [1] : []

                content {
                  name = field_to_match.value.single_header
                }
              }
              dynamic "single_query_argument" {
                for_each = field_to_match.value.single_query_argument != null ? [1] : []

                content {
                  name = field_to_match.value.single_query_argument
                }
              }

              dynamic "uri_path" {
                for_each = field_to_match.value.uri_path != null ? [1] : []

                content {}
              }
            }
          }

          dynamic "text_transformation" {
            for_each = { for text_transformation_rule in try(rule.value.text_transformation, []) : text_transformation_rule.priority => text_transformation_rule }

            content {
              priority = text_transformation.value.priority
              type     = text_transformation.value.type
            }
          }
        }
      }


      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-${rule.value.name}"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {

    for_each = { for rule in try(var.xss_match_statement_rules, []) : rule.name => rule }

    content {
      name     = "waf-${var.global_rule}-${rule.value.name}"
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []

          content {}
        }
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []

          content {}
        }
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []

          content {}
        }
      }

      statement {
        xss_match_statement {

          dynamic "field_to_match" {
            for_each = rule.value.xss_match_statement

            content {
              dynamic "all_query_arguments" {
                for_each = field_to_match.value.all_query_arguments != null ? [1] : []

                content {}
              }

              dynamic "body" {
                for_each = field_to_match.value.body != null ? [1] : []

                content {}
              }

              dynamic "method" {
                for_each = field_to_match.value.method != null ? [1] : []

                content {}
              }

              dynamic "query_string" {
                for_each = field_to_match.value.query_string != null ? [1] : []

                content {}
              }
              dynamic "single_header" {
                for_each = field_to_match.value.single_header != null ? [1] : []

                content {
                  name = ield_to_match.value.single_header
                }
              }
              dynamic "single_query_argument" {
                for_each = field_to_match.value.single_query_argument != null ? [1] : []

                content {
                  name = field_to_match.value.single_query_argument
                }
              }

              dynamic "uri_path" {
                for_each = field_to_match.value.uri_path != null ? [1] : []

                content {}
              }
            }
          }

          dynamic "text_transformation" {
            for_each = { for text_transformation_rule in try(rule.value.text_transformation, []) : text_transformation_rule.priority => text_transformation_rule }

            content {
              priority = text_transformation.value.priority
              type     = text_transformation.value.type
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${var.global_rule}-${rule.value.name}"
        sampled_requests_enabled   = false
      }
    }
  }

  tags = {
    Name = "waf-cloudfront-${var.regional_rule}-static-application"
  }
}

resource "aws_wafv2_web_acl_association" "waf_association_alb" {
  count        = var.associate_alb ? 1 : 0
  resource_arn = var.alb_arn
  #resource_arn = var.api_gateway_arn
  web_acl_arn = aws_wafv2_web_acl.waf_regional[count.index].arn
}