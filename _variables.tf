
variable "waf_cloudfront_enable" {
  type        = bool
  description = "Enable WAF for Cloudfront distribution"
  default     = false
}

variable "waf_regional_enable" {
  type        = bool
  description = "Enable WAFv2 to ALB, API Gateway or AppSync GraphQL API"
  default     = false
}

variable "global_rule" {
  description = "Cloudfront WAF Rule Name"
  type        = string
  default     = ""
}

variable "regional_rule" {
  description = "Regional WAF Rules for ALB and API Gateway"
  type        = string
  default     = ""
}

variable "scope" {
  type        = string
  description = "The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL(ALB)."
}

########## Associate WAFv2 Rules to CloudFront, ALB or API Gateway

variable "web_acl_id" {
  description = "Specify a web ACL ARN to be associated in CloudFront Distribution / # Optional WEB ACLs (WAF) to attach to CloudFront"
  type        = string
  default     = null
}

variable "associate_alb" {
  type        = bool
  description = "Whether to associate an ALB with the WAFv2 ACL."
  default     = false
}

variable "alb_arn" {
  type        = string
  description = "ARN of the ALB to be associated with the WAFv2 ACL."
  default     = ""
}

variable "api_gateway_arn" {
  type        = string
  description = "ARN of the API Gateway to be associated with the WAFv2 ACL."
  default     = ""
}

########################################################
##### List of Statement Rules ##########################

variable "byte_match_statement_rules" {
  type = list(object({
    name     = string
    priority = number
    action   = string
    byte_matchs = list(object({
      positional_constraint = string
      search_string         = string
    }))
    byte_match_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = string
      type     = string
    }))
  }))
}

variable "geo_match_statement_rules" {
  type = list(object({
    name          = string
    priority      = string
    action        = string
    country_codes = list(string)
    geo_match_statement = list(object({
      fallback_behavior = string
      header_name       = string
    }))
  }))
}

variable "ip_set_reference_statement_rules" {
  type = list(object({
    name     = string
    priority = string
    action   = string
    ip_set   = list(string)
    ip_set_reference_statement = list(object({
      fallback_behavior = string
      header_name       = string
      position          = string
    }))
  }))
}

variable "managed_rule_group_statement_rules" {
  type = list(object({
    name            = string
    priority        = string
    override_action = string
    managed_rule_group_statement = list(object({
      name        = string
      vendor_name = string
      excluded_rule = list(object({
        name = string
      }))
    }))
  }))
}

variable "rate_based_statement_rules" {
  type = list(object({
    name     = string
    priority = string
    action   = string
    rate_based = list(object({
      aggregate_key_type = string
      limit              = number
    }))
    rate_based_statement = list(object({
      fallback_behavior = string
      header_name       = string
    }))
  }))
}

variable "regex_pattern_set_reference_statement_rules" {
  type = list(object({
    name      = string
    priority  = string
    action    = string
    regex_set = list(string)
    regex_pattern_set_reference_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = number
      type     = string
    }))
  }))
}

variable "size_constraint_statement_rules" {
  type = list(object({
    name                = string
    priority            = string
    action              = string
    comparison_operator = string
    size                = number
    size_constraint_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = number
      type     = string
    }))
  }))
}

variable "sqli_match_statement_rules" {
  type = list(object({
    name     = string
    priority = string
    action   = string
    sqli_match_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = number
      type     = string
    }))
  }))
}

variable "xss_match_statement_rules" {
  type = list(object({
    name     = string
    priority = string
    action   = string
    xss_match_statement = list(object({
      all_query_arguments   = string
      body                  = string
      method                = string
      query_string          = string
      single_header         = string
      single_query_argument = string
      uri_path              = string
    }))
    text_transformation = list(object({
      priority = number
      type     = string
    }))
  }))
}

variable "default_action" {
  type    = string
  default = "block"
}

variable "visibility_config" {
  type    = map(string)
  default = {}
}

variable "association_resource_arns" {
  type    = list(string)
  default = []
}

variable "log_destination_configs" {
  type    = list(string)
  default = []
}

variable "redacted_fields" {
  type    = map(any)
  default = {}
}