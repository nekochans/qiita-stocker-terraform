// TODO リリース当日にこのファイルを削除する
resource "aws_waf_ipset" "admin_app_ipset" {
  name = "${terraform.workspace}AdminAppIpset"

  // AWS LoftIP
  ip_set_descriptors {
    type  = "IPV4"
    value = "111.108.8.42/32"
  }

  // keitakn
  ip_set_descriptors {
    type  = "IPV4"
    value = "153.160.4.181/32"
  }

  // kobayashi-m42
  ip_set_descriptors {
    type  = "IPV4"
    value = "111.239.168.246/32"
  }
}

resource "aws_waf_rule" "admin_app_rule" {
  depends_on  = ["aws_waf_ipset.admin_app_ipset"]
  metric_name = "${terraform.workspace}AdminAppRule"
  name        = "${terraform.workspace}AdminAppRule"

  predicates {
    data_id = "${aws_waf_ipset.admin_app_ipset.id}"
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "admin_app_acl" {
  depends_on = ["aws_waf_ipset.admin_app_ipset", "aws_waf_rule.admin_app_rule"]

  "default_action" {
    type = "BLOCK"
  }

  metric_name = "${terraform.workspace}AdminAppAcl"
  name        = "${terraform.workspace}AdminAppAcl"

  rules {
    "action" {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = "${aws_waf_rule.admin_app_rule.id}"
    type     = "REGULAR"
  }
}
