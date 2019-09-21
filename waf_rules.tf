resource "aws_waf_rule" "sql_injection_rule" {
  count       = var.sql_injection ? 1 : 0
  depends_on  = ["aws_waf_sql_injection_match_set.sql_injection_set"]
  name        = "SQL Injection Rule"
  metric_name = "SQLInjectionRule"

  predicates {
    data_id = aws_waf_sql_injection_match_set.sql_injection_set[count.index].id
    negated = false
    type    = "SqlInjectionMatch"
  }
}

resource "aws_waf_rule" "xss_rule" {
  count       = var.cross_site_scripting ? 1 : 0
  depends_on  = ["aws_waf_xss_match_set.xss_set"]
  name        = "XSS Rule"
  metric_name = "XssRule"

  predicates {
    data_id = aws_waf_xss_match_set.xss_set[count.index].id
    negated = false
    type    = "XssMatch"
  }
}
