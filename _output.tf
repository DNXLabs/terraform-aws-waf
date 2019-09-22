output "waf_acl_arn" {
  value       = aws_waf_web_acl.waf_acl.arn
  description = "WAF ACL arn"
}
