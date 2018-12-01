resource "aws_security_group" "api" {
  name        = "${terraform.workspace}-${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}"
  description = "Security Group to ${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}_${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_instance" "api_1a" {
  ami                         = "${lookup(var.api, "${terraform.env}.ami", var.api["default.ami"])}"
  associate_public_ip_address = false
  instance_type               = "${lookup(var.api, "${terraform.env}.instance_type", var.api["default.instance_type"])}"

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "${lookup(var.api, "${terraform.env}.volume_type", var.api["default.volume_type"])}"
    volume_size = "${lookup(var.api, "${terraform.env}.volume_size", var.api["default.volume_size"])}"
  }

  key_name               = "${lookup(var.bastion, "key_pair_id")}"
  subnet_id              = "${var.vpc["subnet_private_1a_id"]}"
  vpc_security_group_ids = ["${aws_security_group.api.id}"]

  tags {
    Name = "${terraform.workspace}_${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}_1a"
  }

  lifecycle {
    ignore_changes = [
      "*",
    ]
  }
}
