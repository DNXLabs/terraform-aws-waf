# terraform-aws-waf

[![Lint Status](https://github.com/DNXLabs/terraform-aws-waf/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-waf/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-waf)](https://github.com/DNXLabs/terraform-aws-waf/blob/master/LICENSE)

This terraform module creates two type of WAFv2 Web ACL rules:
  - CLOUDFRONT is a Global rule used in CloudFront Distribution only
  - REGIONAL rules can be used in ALB, API Gateway or AppSync GraphQL API

Follow a commum list of Web ACL rules that can be used by this module and how to setup it, also a link of the documentation with a full list of AWS WAF Rules, you need to use the "Name" of the Rule Groups and take care with WCUs, it's why Web ACL rules can't exceed 1500 WCUs.

  - byte_match_statement
  - geo_match_statement
  - ip_set_reference_statement
  - managed_rule_group_statement
    - AWSManagedRulesCommonRuleSet
    - AWSManagedRulesAmazonIpReputationList
    - AWSManagedRulesKnownBadInputsRuleSet
    - AWSManagedRulesSQLiRuleSet
    - AWSManagedRulesLinuxRuleSet
    - AWSManagedRulesUnixRuleSet
  - rate_based_statement
  - regex_pattern_set_reference_statement
  - size_constraint_statement
  - sqli_match_statement
  - xss_match_statement

## Usage

```hcl

module "terraform_aws_wafv2_global" {
  source   = "git::https://github.com/DNXLabs/terraform-aws-waf.git?ref=1.1.0"
  for_each = { for rule in try(local.workspace.wafv2_global.rules, []) : rule.global_rule => rule }

  waf_cloudfront_enable = try(each.value.waf_cloudfront_enable, false)
  web_acl_id            = try(each.value.web_acl_id, "") # Optional WEB ACLs (WAF) to attach to CloudFront
  global_rule           = try(each.value.global_rule, [])
  scope                 = each.value.scope
  default_action        = try(each.value.default_action, "block")

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

data "aws_wafv2_web_acl" "web_acl_arn" {
# count = local.workspace.wafv2.global.waf_cloudfront_web_acl_enable ? 1 : 0
depends_on = [module.terraform_aws_wafv2_global]
provider = aws.us-east-1
  name  = "waf-${local.workspace.wafv2.global.acls.global_rule_name}"
  scope = "CLOUDFRONT"
}

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
}q
```

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| associate\_waf | Whether to associate an ALB with the WAFv2 ACL. | `bool` | `false` | no |
| byte\_match\_statement\_rules | n/a | <pre>list(object({<br>    name     = string<br>    priority = number<br>    action   = string<br>    byte_matchs = list(object({<br>      positional_constraint = string<br>      search_string         = string<br>    }))<br>    byte_match_statement = list(object({<br>      all_query_arguments   = string<br>      body                  = string<br>      method                = string<br>      query_string          = string<br>      single_header         = string<br>      single_query_argument = string<br>      uri_path              = string<br>    }))<br>    text_transformation = list(object({<br>      priority = string<br>      type     = string<br>    }))<br>  }))</pre> | n/a | yes |
| default\_action | n/a | `string` | `"block"` | no |
| geo\_match\_statement\_rules | n/a | <pre>list(object({<br>    name          = string<br>    priority      = string<br>    action        = string<br>    country_codes = list(string)<br>    geo_match_statement = list(object({<br>      fallback_behavior = string<br>      header_name       = string<br>    }))<br>  }))</pre> | n/a | yes |
| global\_rule | Cloudfront WAF Rule Name | `string` | `""` | no |
| ip\_set\_reference\_statement\_rules | n/a | <pre>list(object({<br>    name     = string<br>    priority = string<br>    action   = string<br>    ip_set   = list(string)<br>    ip_set_reference_statement = list(object({<br>      fallback_behavior = string<br>      header_name       = string<br>      position          = string<br>    }))<br>  }))</pre> | n/a | yes |
| logging\_filter | n/a | <pre>list(object({<br>    default_behavior = string<br>    filter = list(object({<br>      behavior    = string<br>      requirement = string<br>      condition = list(object({<br>        action_condition     = string<br>        label_name_condition = string<br>      }))<br>    }))<br>  }))</pre> | n/a | yes |
| logging\_redacted\_fields | n/a | <pre>list(object({<br>    all_query_arguments   = string<br>    body                  = string<br>    method                = string<br>    query_string          = string<br>    single_header         = string<br>    single_query_argument = string<br>    uri_path              = string<br>  }))</pre> | n/a | yes |
| logs\_enable | Enable logs | `bool` | `false` | no |
| logs\_retension | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `number` | `90` | no |
| managed\_rule\_group\_statement\_rules | n/a | <pre>list(object({<br>    name            = string<br>    priority        = string<br>    override_action = string<br>    managed_rule_group_statement = list(object({<br>      name        = string<br>      vendor_name = string<br>      excluded_rule = list(object({<br>        name = string<br>      }))<br>    }))<br>  }))</pre> | n/a | yes |
| rate\_based\_statement\_rules | n/a | <pre>list(object({<br>    name     = string<br>    priority = string<br>    action   = string<br>    rate_based = list(object({<br>      aggregate_key_type = string<br>      limit              = number<br>    }))<br>    rate_based_statement = list(object({<br>      fallback_behavior = string<br>      header_name       = string<br>    }))<br>  }))</pre> | n/a | yes |
| regex\_pattern\_set\_reference\_statement\_rules | n/a | <pre>list(object({<br>    name      = string<br>    priority  = string<br>    action    = string<br>    regex_set = list(string)<br>    regex_pattern_set_reference_statement = list(object({<br>      all_query_arguments   = string<br>      body                  = string<br>      method                = string<br>      query_string          = string<br>      single_header         = string<br>      single_query_argument = string<br>      uri_path              = string<br>    }))<br>    text_transformation = list(object({<br>      priority = number<br>      type     = string<br>    }))<br>  }))</pre> | n/a | yes |
| regional\_rule | Regional WAF Rules for ALB and API Gateway | `string` | `""` | no |
| resource\_arn | ARN of the ALB to be associated with the WAFv2 ACL. | `list(string)` | `[]` | no |
| scope | The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL(ALB). | `string` | n/a | yes |
| size\_constraint\_statement\_rules | n/a | <pre>list(object({<br>    name                = string<br>    priority            = string<br>    action              = string<br>    comparison_operator = string<br>    size                = number<br>    size_constraint_statement = list(object({<br>      all_query_arguments   = string<br>      body                  = string<br>      method                = string<br>      query_string          = string<br>      single_header         = string<br>      single_query_argument = string<br>      uri_path              = string<br>    }))<br>    text_transformation = list(object({<br>      priority = number<br>      type     = string<br>    }))<br>  }))</pre> | n/a | yes |
| sqli\_match\_statement\_rules | n/a | <pre>list(object({<br>    name     = string<br>    priority = string<br>    action   = string<br>    sqli_match_statement = list(object({<br>      all_query_arguments   = string<br>      body                  = string<br>      method                = string<br>      query_string          = string<br>      single_header         = string<br>      single_query_argument = string<br>      uri_path              = string<br>    }))<br>    text_transformation = list(object({<br>      priority = number<br>      type     = string<br>    }))<br>  }))</pre> | n/a | yes |
| waf\_cloudfront\_enable | Enable WAF for Cloudfront distribution | `bool` | `false` | no |
| waf\_regional\_enable | Enable WAFv2 to ALB, API Gateway or AppSync GraphQL API | `bool` | `false` | no |
| web\_acl\_id | Specify a web ACL ARN to be associated in CloudFront Distribution / # Optional WEB ACLs (WAF) to attach to CloudFront | `string` | `null` | no |
| xss\_match\_statement\_rules | n/a | <pre>list(object({<br>    name     = string<br>    priority = string<br>    action   = string<br>    xss_match_statement = list(object({<br>      all_query_arguments   = string<br>      body                  = string<br>      method                = string<br>      query_string          = string<br>      single_header         = string<br>      single_query_argument = string<br>      uri_path              = string<br>    }))<br>    text_transformation = list(object({<br>      priority = number<br>      type     = string<br>    }))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_arn | The ARN of the WAFv2 WebACL. |
| web\_acl\_capacity\_cloudfront | The web ACL capacity units (WCUs) currently being used by this web ACL. |
| web\_acl\_capacity\_regional | The web ACL capacity units (WCUs) currently being used by this web ACL. |
| web\_acl\_id | The ID of the WAFv2 WebACL. |
| web\_acl\_name\_cloudfront | The name of the WAFv2 WebACL. |
| web\_acl\_name\_regional | The name of the WAFv2 WebACL. |
| web\_acl\_visibility\_config\_name\_cloudfront | The web ACL visibility config name |
| web\_acl\_visibility\_config\_name\_regional | The web ACL visibility config name |

<!--- END_TF_DOCS --->


## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-waf/blob/master/LICENSE) for full details.