
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

variable "wafv2_rate_limit_rule" {
  type        = number
  default     = 0
  description = "The limit on requests per 5-minute period for a single originating IP address (leave 0 to disable)"
}

variable "wafv2_managed_rule_groups" {
  type        = list(string)
  default     = ["AWSManagedRulesCommonRuleSet"]
  description = "List of WAF V2 managed rule groups, set to count"
}

variable "wafv2_managed_block_rule_groups" {
  type        = list(string)
  default     = []
  description = "List of WAF V2 managed rule groups, set to block"
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
##### Aditional Rules (Optional) #######################

variable "managed_rules" {
  type = list(object({
    name            = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
  }))
  description = "List of Managed WAF rules."
  default = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 10
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesAmazonIpReputationList",
      priority        = 20
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 30
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet",
      priority        = 40
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 50
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesUnixRuleSet",
      priority        = 60
      override_action = "none"
      excluded_rules  = []
    }
  ]
}

variable "ip_sets_rule" {
  type = list(object({
    name       = string
    priority   = number
    ip_set_arn = string
    action     = string
  }))
  description = "A rule to detect web requests coming from particular IP addresses or address ranges."
  default     = []
}

variable "ip_rate_based_rule" {
  type = object({
    name     = string
    priority = number
    limit    = number
    action   = string
  })
  description = "A rate-based rule tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span"
  default     = null
}

variable "ip_rate_url_based_rules" {
  type = list(object({
    name                  = string
    priority              = number
    limit                 = number
    action                = string
    search_string         = string
    positional_constraint = string
  }))
  description = "A rate and url based rules tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span"
  default     = []
}

variable "filtered_header_rule" {
  type = object({
    header_types = list(string)
    priority     = number
    header_value = string
    action       = string
  })
  description = "HTTP header to filter . Currently supports a single header type and multiple header values."
  default = {
    header_types = []
    priority     = 1
    header_value = ""
    action       = "block"
  }
}