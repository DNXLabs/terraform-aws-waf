output "web_acl_id" {
  description = "The ID of the WAFv2 WebACL."
  value       = join("", aws_wafv2_web_acl.waf_cloudfront.*.id)
}


output "web_acl_name_cloudfront" {
  description = "The name of the WAFv2 WebACL."
  value       = join("", aws_wafv2_web_acl.waf_cloudfront.*.name)
}

output "web_acl_name_regional" {
  description = "The name of the WAFv2 WebACL."
  value       = join("", aws_wafv2_web_acl.waf_regional.*.name)
}

output "web_acl_arn" {
  description = "The ARN of the WAFv2 WebACL."
  value       = join("", aws_wafv2_web_acl.waf_cloudfront.*.arn)
}


output "web_acl_capacity_cloudfront" {
  description = "The web ACL capacity units (WCUs) currently being used by this web ACL."
  value       = join("", aws_wafv2_web_acl.waf_cloudfront.*.capacity)
}

output "web_acl_capacity_regional" {
  description = "The web ACL capacity units (WCUs) currently being used by this web ACL."
  value       = join("", aws_wafv2_web_acl.waf_regional.*.capacity)
}

output "web_acl_visibility_config_name_regional" {
  description = "The web ACL visibility config name"
  value       = var.waf_regional_enable ? aws_wafv2_web_acl.waf_regional[0].visibility_config[0].metric_name : ""
}

output "web_acl_visibility_config_name_cloudfront" {
  description = "The web ACL visibility config name"
  value       = var.waf_cloudfront_enable ? aws_wafv2_web_acl.waf_cloudfront[0].visibility_config[0].metric_name : ""
}

# output "capacity" {
#   value       = aws_wafv2_web_acl.waf_acl.capacity 
#   description = "WAF ACL arn to be consumed"
# }