data "aws_iam_policy_document" "trust_relationship" {
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
  assume_role_policy = "${data.aws_iam_policy_document.trust_relationship.json}"
}

resource "aws_iam_policy_attachment" "task_execution_role_attach" {
  name       = "ecs-task-role-attach"
  roles      = ["${aws_iam_role.task_execution_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
