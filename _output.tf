output "id" {
  value       = aws_wafv2_web_acl.waf_acl.id
  description = "WAF ACL arn to be consumed"
}

output "capacity" {
  value       = aws_wafv2_web_acl.waf_acl.capacity 
  description = "WAF ACL arn to be consumed"
}