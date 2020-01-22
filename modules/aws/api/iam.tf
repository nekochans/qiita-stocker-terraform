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
  count              = terraform.workspace != "prod" ? 1 : 0
  name               = "${terraform.workspace}-ecs-service-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_trust_relationship.json
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_attach" {
  count      = terraform.workspace != "prod" ? 1 : 0
  role       = aws_iam_role.ecs_service_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "task_execution_trust_relationship" {
  statement {
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
  assume_role_policy = data.aws_iam_policy_document.task_execution_trust_relationship.json
}

resource "aws_iam_role_policy_attachment" "task_execution_role_attach" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_read_only_access_role_attach" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

data "aws_iam_policy_document" "datadog_agent_container_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:DescribeContainerInstances",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecs_instance" {
  name   = "${terraform.workspace}-datadog-agent-container-policy"
  role   = aws_iam_role.task_execution_role.id
  policy = data.aws_iam_policy_document.datadog_agent_container_policy.json
}
