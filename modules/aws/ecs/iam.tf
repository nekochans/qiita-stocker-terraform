data "aws_iam_policy_document" "trust_relationship" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_service" {
  "statement" {
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_cluster_instance" {
  "statement" {
    effect = "Allow"

    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_service" {
  count              = "${terraform.workspace != "prod" ? 1 : 0}"
  name               = "${terraform.workspace}-ecs-role"
  assume_role_policy = "${data.aws_iam_policy_document.trust_relationship.json}"
}

resource "aws_iam_role_policy" "ecs_service_role" {
  count  = "${terraform.workspace != "prod" ? 1 : 0}"
  name   = "${terraform.workspace}-ecs-service-role-policy"
  role   = "${aws_iam_role.ecs_service.id}"
  policy = "${data.aws_iam_policy_document.ecs_service.json}"
}

resource "aws_iam_role_policy" "ecs_instance" {
  count  = "${terraform.workspace != "prod" ? 1 : 0}"
  name   = "${terraform.workspace}-ecs-instance-policy"
  role   = "${aws_iam_role.ecs_service.id}"
  policy = "${data.aws_iam_policy_document.ecs_cluster_instance.json}"
}
