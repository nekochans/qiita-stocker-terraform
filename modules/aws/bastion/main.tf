resource "aws_security_group" "bastion" {
  name        = "${terraform.workspace}-${lookup(var.bastion, "${terraform.env}.name", var.bastion["default.name"])}"
  description = "Security Group to ${lookup(var.bastion, "${terraform.env}.name", var.bastion["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}-${lookup(var.bastion, "${terraform.env}.name", var.bastion["default.name"])}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
