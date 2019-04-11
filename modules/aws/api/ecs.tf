resource "aws_security_group" "ecs_api" {
  count       = "${terraform.workspace != "prod" ? 1 : 0}"
  name        = "${lookup(var.ecs, "${terraform.env}.name", var.ecs["default.name"])}"
  description = "Security Group to ${lookup(var.ecs, "${terraform.env}.name", var.ecs["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${lookup(var.ecs, "${terraform.env}.name", var.ecs["default.name"])}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ecs_api_from_alb" {
  count                    = "${terraform.workspace != "prod" ? 1 : 0}"
  security_group_id        = "${aws_security_group.ecs_api.id}"
  type                     = "ingress"
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.ecs_alb.id}"
}

resource "aws_security_group_rule" "ssh_from_bastion_to_ecs_api" {
  count                    = "${terraform.workspace != "prod" ? 1 : 0}"
  security_group_id        = "${aws_security_group.ecs_api.id}"
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = "${lookup(var.bastion, "bastion_security_id")}"
}

resource "aws_security_group_rule" "rds_from_ecs_api_server" {
  count                    = "${terraform.workspace != "prod" ? 1 : 0}"
  security_group_id        = "${lookup(var.rds, "rds_security_id")}"
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.ecs_api.id}"
}

data "template_file" "user_data" {
  count    = "${terraform.workspace != "prod" ? 1 : 0}"
  template = "${file("../../../../modules/aws/api/user-data/userdata.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.api_ecs_cluster.name}"
  }
}

resource "aws_instance" "ecs_instance" {
  count                       = "${terraform.workspace != "prod" ? 1 : 0}"
  ami                         = "${lookup(var.ecs, "${terraform.env}.ami", var.ecs["default.ami"])}"
  associate_public_ip_address = "false"
  instance_type               = "${lookup(var.ecs, "${terraform.env}.instance_type", var.ecs["default.instance_type"])}"
  subnet_id                   = "${var.vpc["subnet_private_1a_id"]}"
  vpc_security_group_ids      = ["${aws_security_group.ecs_api.id}"]
  key_name                    = "${lookup(var.bastion, "key_pair_id")}"

  tags {
    Name = "${lookup(var.ecs, "${terraform.env}.name", var.ecs["default.name"])}-1a"
  }

  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"
  monitoring           = true

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "${lookup(var.ecs, "${terraform.env}.volume_type", var.ecs["default.volume_type"])}"
    volume_size = "${lookup(var.ecs, "${terraform.env}.volume_size", var.ecs["default.volume_size"])}"
  }

  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    ignore_changes = [
      "ebs_block_device",
    ]
  }
}

resource "aws_ecs_cluster" "api_ecs_cluster" {
  count = "${terraform.workspace != "prod" ? 1 : 0}"
  name  = "${lookup(var.ecs, "${terraform.env}.name", var.ecs["default.name"])}"
}

data "template_file" "api_template_file" {
  template = "${file("../../../../modules/aws/api/task/ecs-api.json")}"

  vars {
    php_image_url   = "${element(var.ecr["php_image_url"], 0)}"
    nginx_image_url = "${element(var.ecr["nginx_image_url"], 0)}"
  }
}

resource "aws_ecs_task_definition" "api" {
  count                 = "${terraform.workspace != "prod" ? 1 : 0}"
  family                = "${lookup(var.ecs, "${terraform.env}.name", var.ecs["default.name"])}"
  network_mode          = "bridge"
  container_definitions = "${data.template_file.api_template_file.rendered}"
}

resource "aws_ecs_service" "api_ecs_service" {
  count           = "${terraform.workspace != "prod" ? 1 : 0}"
  name            = "${lookup(var.ecs, "${terraform.env}.name", var.ecs["default.name"])}"
  cluster         = "${aws_ecs_cluster.api_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.api.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs.id}"
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [
    "aws_alb_listener.ecs_alb",
  ]
}
