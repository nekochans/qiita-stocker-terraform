data "aws_route53_zone" "api" {
  name = "${var.main_domain_name}"
}

resource "aws_route53_record" "api" {
  zone_id = "${data.aws_route53_zone.api.zone_id}"
  name    = "${lookup(var.sub_domain_name, "${terraform.env}.name", var.sub_domain_name["default.name"])}"
  type    = "A"

  alias {
    name                   = "${aws_lb.api.dns_name}"
    zone_id                = "${aws_lb.api.zone_id}"
    evaluate_target_health = false
  }
}
