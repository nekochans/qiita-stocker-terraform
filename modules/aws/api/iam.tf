data "aws_iam_policy_document" "ecs_instance_trust_relationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  count              = "${terraform.workspace != "prod" ? 1 : 0}"
  name               = "${terraform.workspace}-ecs-instance-role"
  path               = "/system/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_instance_trust_relationship.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  count      = "${terraform.workspace != "prod" ? 1 : 0}"
  role       = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance" {
  count = "${terraform.workspace != "prod" ? 1 : 0}"
  name  = "${terraform.workspace}-ecs-instance-profile"
  path  = "/"
  role  = "${aws_iam_role.ecs_instance_role.name}"
}

data "aws_iam_policy_document" "ecs_service_trust_relationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_service_role" {
  count              = "${terraform.workspace != "prod" ? 1 : 0}"
  name               = "${terraform.workspace}-ecs-service-role"
  path               = "/system/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_trust_relationship.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_attach" {
  count      = "${terraform.workspace != "prod" ? 1 : 0}"
  role       = "${aws_iam_role.ecs_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "task_execution_trust_relationship" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${terraform.workspace}-task-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.task_execution_trust_relationship.json}"
}

resource "aws_iam_policy_attachment" "task_execution_role_attach" {
  name       = "ecs-task-role-attach"
  roles      = ["${aws_iam_role.task_execution_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
