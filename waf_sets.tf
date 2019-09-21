###################################################################
# SQL Injection Condition
# Filters requests that contain possible malicious SQL code. The condition includes filters that evaluate the following parts of requests:
#     - Query string (URL & HTML decode transformation)
#     - URI (URL & HTML decode transformation)
#     - Body (URL & HTML decode transformation)
###################################################################
resource "aws_waf_sql_injection_match_set" "sql_injection_set" {
  count = var.sql_injection ? 1 : 0
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
  count = var.cross_site_scripting ? 1 : 0
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
