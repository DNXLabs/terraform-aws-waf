output "waf_acl_arn" {
  value       = var.options.enable ? aws_waf_web_acl.waf_acl[*].arn : null
  description = "WAF ACL arn"
}
