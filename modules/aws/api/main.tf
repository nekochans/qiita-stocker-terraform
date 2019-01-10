resource "aws_security_group" "api" {
  name        = "${terraform.workspace}-${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}"
  description = "Security Group to ${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}"
  }

  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = ["${aws_security_group.alb.id}"]
  }

  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = ["${lookup(var.bastion, "bastion_security_id")}"]
  }

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = ["${lookup(var.bastion, "bastion_security_id")}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

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
