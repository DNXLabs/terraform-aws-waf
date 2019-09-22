###################################################################
# SQL Injection Condition
# Filters requests that contain possible malicious SQL code. The condition includes filters that evaluate the following parts of requests:
#     - Query string (URL & HTML decode transformation)
#     - URI (URL & HTML decode transformation)
#     - Body (URL & HTML decode transformation)
###################################################################
resource "aws_waf_sql_injection_match_set" "sql_injection_set" {
  count = var.options.sql_injection ? 1 : 0
  name  = "detect-sqlinjection-set"

  sql_injection_match_tuples {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  sql_injection_match_tuples {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  sql_injection_match_tuples {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  sql_injection_match_tuples {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  sql_injection_match_tuples {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  sql_injection_match_tuples {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }
}

###################################################################
# Cross-site Scripting Condition
# Filters requests that contain possible malicious scripts. The condition includes filters that evaluate the following parts of requests:
#     - Query string (URL & HTML decode transformation)
#     - URI (URL & HTML decode transformation)
#     - Body (URL & HTML decode transformation)
###################################################################

resource "aws_waf_xss_match_set" "xss_set" {
  count = var.options.cross_site_scripting ? 1 : 0
  name  = "detect-xss-set"

  xss_match_tuples {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  xss_match_tuples {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "BODY"
    }
  }

  xss_match_tuples {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  xss_match_tuples {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "URI"
    }
  }

  xss_match_tuples {
    text_transformation = "HTML_ENTITY_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  xss_match_tuples {
    text_transformation = "URL_DECODE"

    field_to_match {
      type = "QUERY_STRING"
    }
  }
}

###################################################################
# IP Blacklist Condition
# Any network range add here will be restricted to access the service
###################################################################
resource "aws_waf_ipset" "ip_set" {
  count = var.options.ip_blacklist.enable ? 1 : 0
  name  = "block-ip-set"

  dynamic "ip_set_descriptors" {
    for_each = var.options.ip_blacklist.enable ? var.options.ip_blacklist.list : []
    content {
      type  = "IPV4"
      value = ip_set_descriptors.value
    }
  }
}
