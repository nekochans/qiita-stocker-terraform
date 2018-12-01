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
    security_groups = ["${var.bastion_security_id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
