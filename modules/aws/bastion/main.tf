resource "aws_security_group" "bastion" {
  name = "${terraform.workspace}-${lookup(
    var.bastion,
    "${terraform.workspace}.name",
    var.bastion["default.name"]
  )}"
  description = "Security Group to ${lookup(
    var.bastion,
    "${terraform.workspace}.name",
    var.bastion["default.name"]
  )}"
  vpc_id = var.vpc["vpc_id"]

  tags = {
    Name = "${terraform.workspace}-${lookup(
      var.bastion,
      "${terraform.workspace}.name",
      var.bastion["default.name"]
    )}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ssh_key_pair" {
  public_key = file(var.ssh_public_key_path)
  key_name   = "${terraform.workspace}-ssh-key"
}

resource "aws_security_group_rule" "ssh_from_workplace" {
  security_group_id = aws_security_group.bastion.id
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "bastion_1a" {
  ami = lookup(
    var.bastion,
    "${terraform.workspace}.ami",
    var.bastion["default.ami"]
  )
  associate_public_ip_address = true
  instance_type = lookup(
    var.bastion,
    "${terraform.workspace}.instance_type",
    var.bastion["default.instance_type"]
  )

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = lookup(
      var.bastion,
      "${terraform.workspace}.volume_type",
      var.bastion["default.volume_type"]
    )
    volume_size = lookup(
      var.bastion,
      "${terraform.workspace}.volume_size",
      var.bastion["default.volume_size"]
    )
  }

  key_name               = aws_key_pair.ssh_key_pair.id
  subnet_id              = var.vpc["subnet_public_1a_id"]
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "${terraform.workspace}-${lookup(
      var.bastion,
      "${terraform.workspace}.name",
      var.bastion["default.name"]
    )}-1a"
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_eip" "bastion_ip_1a" {
  instance = aws_instance.bastion_1a.id

  tags = {
    Name = "${terraform.workspace}-bastion-1a"
  }
}
