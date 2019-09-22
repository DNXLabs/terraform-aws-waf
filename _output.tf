output "id" {
  value       = aws_waf_web_acl.waf_acl.id
  description = "WAF ACL arn to be consumed"
}
