# terraform-aws-waf

[![Lint Status](https://github.com/DNXLabs/terraform-aws-waf/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-waf/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-waf)](https://github.com/DNXLabs/terraform-aws-waf/blob/master/LICENSE)

This terraform module creates two type of WAFv2 Web ACL rules:
  - CLOUDFRONT is a Global rule used in CloudFront Distribution only
  - REGIONAL rules can be used in ALB, API Gateway or AppSync GraphQL API

Follow a commum list of Web ACL rules that can be used by this module and how to setup it, also a link of the documentation with a full list of AWS WAF Rules, you need to use the "Name" of the Rule Groups and take care with WCUs, it's why Web ACL rules can't exceed 1500 WCUs.

  - AWSManagedRulesCommonRuleSet
  - AWSManagedRulesAmazonIpReputationList
  - AWSManagedRulesAnonymousIpList
  - AWSManagedRulesKnownBadInputsRuleSet
  - wafv2_rate_limit_rule: 2000

Ref.: https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html


## Usage

```hcl

module "terraform_aws_wafv2_global" {
  source   = "git::https://github.com/DNXLabs/terraform-aws-waf.git?ref=0.2.0"
  for_each = { for rule in try(local.workspace.wafv2_global.rules, []) : rule.global_rule => rule }

  providers = {
    aws = aws.us-east-1
    }

  waf_cloudfront_enable     = try(each.value.waf_cloudfront_enable, false)
  web_acl_id                = try(each.value.web_acl_id, "") # Optional WEB ACLs (WAF) to attach to CloudFront

  global_rule               = try(each.value.global_rule, [])
  wafv2_managed_rule_groups = try(each.value.wafv2_managed_rule_groups, [])
  wafv2_rate_limit_rule     = try(each.value.wafv2_rate_limit_rule, 0)
  scope                     = each.value.scope
}


module "terraform_aws_wafv2_regional" {
  source   = "git::https://github.com/DNXLabs/terraform-aws-waf.git?ref=0.2.0"
  for_each = { for rule in try(local.workspace.wafv2_regional.rules, []) : rule.regional_rule => rule }

  waf_regional_enable       = try(each.value.waf_regional_enable, false)  # WAFv2 to ALB, API Gateway or AppSync GraphQL API
  associate_alb             = try(each.value.associate_alb, false)
  alb_arn                   = try(each.value.alb_arn, "")
  api_gateway_arn           = try(each.value.api_gateway_arn, "")

  regional_rule             = try(each.value.regional_rule, [])
  wafv2_managed_rule_groups = try(each.value.wafv2_managed_rule_groups, [])
  wafv2_rate_limit_rule     = try(each.value.wafv2_rate_limit_rule, 0)
  scope                     = each.value.scope
}
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
| cross\_site\_scripting | n/a | `bool` | `"false"` | no |
| ip\_blacklist | n/a | <pre>object({<br>    enable = bool<br>    list   = list(string)<br>  })</pre> | <pre>{<br>  "enable": "false",<br>  "list": []<br>}</pre> | no |
| sql\_injection | n/a | `bool` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | WAF ACL arn to be consumed |

<!--- END_TF_DOCS --->


## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-waf/blob/master/LICENSE) for full details.