// Fargate
resource "aws_security_group" "fargate_api_alb" {
  name = "${lookup(
    var.fargate,
    "${terraform.workspace}.name",
    var.fargate["default.name"]
  )}-alb"
  description = "Security Group to ${lookup(
    var.fargate,
    "${terraform.workspace}.name",
    var.fargate["default.name"]
  )}-alb"
  vpc_id = var.vpc["vpc_id"]

  tags = {
    Name = "${lookup(
      var.fargate,
      "${terraform.workspace}.name",
      var.fargate["default.name"]
    )}-alb"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "fargate_api_alb" {
  security_group_id = aws_security_group.fargate_api_alb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_s3_bucket" "fargate_api_alb_logs" {
  bucket = "${lookup(
    var.fargate,
    "${terraform.workspace}.name",
    var.fargate["default.name"]
  )}-alb-logs"
  force_destroy = true
}

data "aws_iam_policy_document" "put_fargate_api_alb_logs_policy" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.fargate_api_alb_logs.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.aws_elb_service_account.id]
    }
  }
}

resource "aws_s3_bucket_policy" "fargate_api" {
  bucket = aws_s3_bucket.fargate_api_alb_logs.id
  policy = data.aws_iam_policy_document.put_fargate_api_alb_logs_policy.json
}

resource "aws_alb" "fargate_alb" {
  name = lookup(
    var.fargate,
    "${terraform.workspace}.name",
    var.fargate["default.name"]
  )
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.fargate_api_alb.id]
  subnets                    = [var.vpc["subnet_public_1a_id"], var.vpc["subnet_public_1c_id"], var.vpc["subnet_public_1d_id"]]
  enable_deletion_protection = false

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.fargate_api_alb_logs.bucket
  }

  tags = {
    Name = "${lookup(
      var.fargate,
      "${terraform.workspace}.name",
      var.fargate["default.name"]
    )}-alb"
  }
}

resource "aws_alb_target_group" "fargate_api_blue" {
  name = "${lookup(
    var.fargate,
    "${terraform.workspace}.name",
    var.fargate["default.name"]
  )}-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc["vpc_id"]

  health_check {
    path                = "/api/statuses"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 20
    matcher             = 200
  }

  target_type = "ip"
}

resource "aws_alb_target_group" "fargate_api_green" {
  name = "${lookup(
    var.fargate,
    "${terraform.workspace}.name",
    var.fargate["default.name"]
  )}-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc["vpc_id"]

  health_check {
    path                = "/api/statuses"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 20
    matcher             = 200
  }

  target_type = "ip"
}

resource "aws_alb_listener" "fargate_alb" {
  load_balancer_arn = aws_alb.fargate_alb.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.main.arn

  lifecycle {
    ignore_changes = [default_action]
  }

  default_action {
    target_group_arn = aws_alb_target_group.fargate_api_blue.id
    type             = "forward"
  }
}
