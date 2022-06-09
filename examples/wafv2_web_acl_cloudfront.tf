
resource "aws_cloudfront_distribution" "default" {
  count               = try(local.workspace.cloudfront.enabled, false) ? 1 : 0  
  enabled             = local.workspace.cloudfront.enabled
  is_ipv6_enabled     = true
  comment             = join(", ", try(local.workspace.cloudfront.hostnames, []))
  aliases             = try(local.workspace.cloudfront.hostnames, [])
  price_class         = "PriceClass_All"
  wait_for_deployment = false

    depends_on = [module.terraform_aws_wafv2_global]                # Depends-on WAF module to associate Web ACL to CloudFront  
    web_acl_id = try(data.aws_wafv2_web_acl.web_acl_arn[0].arn, )   # Associate WAF Web ACL to CloudFront 

  origin {
    domain_name = try(local.workspace.cloudfront.lb_dns_name, )
    origin_id   = "default"

    custom_origin_config {
      origin_protocol_policy   = "https-only"
      http_port                = 80
      https_port               = 443
      origin_ssl_protocols     = ["SSLv3", "TLSv1.1", "TLSv1.2", "TLSv1"]
      origin_keepalive_timeout = try(local.workspace.cloudfront.cloudfront_origin_keepalive_timeout, "")
      origin_read_timeout      = try(local.workspace.cloudfront.cloudfront_origin_read_timeout, "")
    }

#     custom_header {
#       name  = "fromcloudfront"
#       value = local.workspace.cloudfront.lb_cloudfront_key # ((Optional) - One or more sub-resources with name and value parameters that specify header data that will be sent to the origin (multiples allowed).)
#     }
  }


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "default"
    compress         = true

    forwarded_values {
      query_string = true
      headers      = try(local.workspace.cloudfront.cloudfront_forward_headers, "")

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  viewer_certificate {
    acm_certificate_arn            = try(local.workspace.cloudfront.certificate_arn, "")
    # iam_certificate_id             try(= try(local.workspace.cloudfront.iam_certificate_id, [])
    cloudfront_default_certificate = try(local.workspace.cloudfront.certificate_arn, "") == null && try(local.workspace.cloudfront.iam_certificate_id, []) == null ? true : false
    ssl_support_method             = try(local.workspace.cloudfront.certificate_arn, "") == null && try(local.workspace.cloudfront.iam_certificate_id, []) == null ? null : "sni-only"
    minimum_protocol_version       = try(local.workspace.cloudfront.certificate_arn, "") == null && try(local.workspace.cloudfront.iam_certificate_id, []) == null ? "TLSv1.2_2018" : local.workspace.cloudfront.minimum_protocol_version
  }

  restrictions {
    geo_restriction {
      restriction_type = try(local.workspace.cloudfront.restriction_type, [])
      locations        = try(local.workspace.cloudfront.restriction_location, [])
    }
  }

}