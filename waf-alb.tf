

















resource "aws_wafv2_web_acl_association" "waf_association_alb" {
  count = var.associate_alb ? 1 : 0

  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.waf_alb.arn
}