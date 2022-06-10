resource "aws_wafv2_web_acl_association" "waf_association_alb" {
#   count        = var.associate_alb ? 1 : 0
  depends_on = [module.terraform_aws_wafv2_regional]  
  resource_arn = var.alb_arn   # resource_arn = var.api_gateway_arn
  web_acl_arn = aws_wafv2_web_acl.waf_regional[count.index].arn
}