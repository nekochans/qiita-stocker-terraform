resource "aws_security_group" "alb" {
  name        = "${terraform.workspace}-${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}-alb"
  description = "Security Group to ${lookup(var.api, "${terraform.env}.name", var.api["default.name"])} alb"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}-alb"
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "api_alb_logs" {
  bucket        = "${terraform.workspace}-${var.api["default.project"]}-${var.api["default.name"]}-alb-logs"
  force_destroy = true
}

data "aws_iam_policy_document" "put_api_alb_logs_policy" {
  "statement" {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.api_alb_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.aws_elb_service_account.id}"]
    }
  }
}

resource "aws_s3_bucket_policy" "api" {
  bucket = "${aws_s3_bucket.api_alb_logs.id}"
  policy = "${data.aws_iam_policy_document.put_api_alb_logs_policy.json}"
}

resource "aws_lb" "api" {
  name               = "${terraform.workspace}-${var.api["default.name"]}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = ["${var.vpc["subnet_public_1a_id"]}", "${var.vpc["subnet_public_1c_id"]}", "${var.vpc["subnet_public_1d_id"]}"]

  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket  = "${aws_s3_bucket.api_alb_logs.bucket}"
  }

  tags {
    Name = "${terraform.workspace}-${var.api["default.name"]}-alb"
  }
}

resource "aws_lb_target_group" "api" {
  name     = "${terraform.workspace}-${var.api["default.name"]}"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${lookup(var.vpc, "vpc_id")}"

  health_check {
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 20
    matcher             = 200
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.api.arn}"
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${data.aws_acm_certificate.main.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.api.arn}"
    type             = "forward"
  }
}
