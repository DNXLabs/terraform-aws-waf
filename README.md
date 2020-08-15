# terraform-aws-waf

This terraform module creates a Global Web Application Firewall(WAF) Web Acl to be used with Cloudfront.

Dynamic rules:
 - SQL Injection
   - Filter requests that contain possible malicious SQL code. The condition includes filters that evaluate the following parts of requests:
     - Query string (URL & HTML decode transformation)
     - URI (URL & HTML decode transformation)
     - Body (URL & HTML decode transformation)
 - Cross Site Scripting
   - Filters requests that contain possible malicious scripts. The condition includes filters that evaluate the following parts of requests:
     - Query string (URL & HTML decode transformation)
     - URI (URL & HTML decode transformation)
     - Body (URL & HTML decode transformation)
 - IP Blacklist
   - Any IP range add here will be restricted to access the service
 - Network Blacklist
   - Any network range add here will be restricted to access the service


## Usage

```hcl
module "waf_acl" {
  # source             = "git::https://github.com/DNXLabs/terraform-aws-waf.git?ref=0.1.0"
  sql_injection        = "true"
  cross_site_scripting = "true"
  ip_blacklist         = {
    enable = "true"
    list   = [
      "10.0.0.0/24",
      "192.168.0.0/16"
    ]
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| sql\_injection | Whether to deploy the rule set for sql injection | bool | `"false"` | no |
| cross\_site\_scripting | Whether to deploy the rule set for cross site scripting | bool | `"false"` | no |
| ip\_blacklist.enable | Whether to deploy the rule set for ip blacklist. Requires at least one IP in the blacklist | bool | `"false"` | no |
| ip\_blacklist.list | List of network address to blacklist. `10.0.0.0/8` | list(string) | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | WAF ACL ARN to be attached to CloudFront  |

## Authors

Module managed by [Allan Denot](https://github.com/adenot).

## License

Apache 2 Licensed. See LICENSE for full details.
