data "aws_iam_policy_document" "ec2_trust_relationship" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ec2_policy" {
  "statement" {
    effect = "Allow"

    actions = [
      "s3:*",
      "codedeploy:Batch*",
      "codedeploy:CreateDeployment",
      "codedeploy:Get*",
      "codedeploy:List*",
      "codedeploy:RegisterApplicationRevision",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${terraform.workspace}-ec2-default-role"
  assume_role_policy = "${data.aws_iam_policy_document.ec2_trust_relationship.json}"
}

resource "aws_iam_role_policy" "ec2_role_policy" {
  name   = "${terraform.workspace}-ec2-default-role-policy"
  role   = "${aws_iam_role.ec2_role.id}"
  policy = "${data.aws_iam_policy_document.ec2_policy.json}"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${terraform.workspace}-ec2-instance-profile"
  role = "${aws_iam_role.ec2_role.name}"
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
    Name = "${terraform.workspace}-${lookup(var.api, "${terraform.env}.name", var.api["default.name"])}-1a"
  }

  iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  monitoring           = true

  lifecycle {
    ignore_changes = [
      "*",
    ]
  }
}
