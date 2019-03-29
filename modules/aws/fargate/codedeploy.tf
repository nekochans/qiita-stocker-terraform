data "aws_iam_policy_document" "codedeploy_trust_relationship" {
  "statement" {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "codedeploy.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "codedeploy_policy" {
  "statement" {
    effect = "Allow"

    actions = ["iam:PassRole"]

    resources = ["*"]
  }
}

resource "aws_iam_role" "codedeploy_role" {
  name               = "${terraform.workspace}-fargate-codedeploy-role"
  assume_role_policy = "${data.aws_iam_policy_document.codedeploy_trust_relationship.json}"
}

resource "aws_iam_role_policy" "codedeploy" {
  name   = "${terraform.workspace}-fargate-codedeploy"
  role   = "${aws_iam_role.codedeploy_role.id}"
  policy = "${data.aws_iam_policy_document.codedeploy_policy.json}"
}

resource "aws_iam_role_policy_attachment" "codedeploy_role" {
  role       = "${aws_iam_role.codedeploy_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_ecs" {
  role       = "${aws_iam_role.codedeploy_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECSLimited"
}

resource "aws_codedeploy_app" "fargate_api" {
  compute_platform = "ECS"
  name             = "${lookup(var.fargate, "${terraform.env}.name", var.fargate["default.name"])}"
}

resource "aws_codedeploy_deployment_group" "fargate_api_blue_green_deploy" {
  app_name               = "${aws_codedeploy_app.fargate_api.name}"
  deployment_group_name  = "blue-green"
  service_role_arn       = "${aws_iam_role.codedeploy_role.arn}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = "1"
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = "${aws_ecs_cluster.api_fargate_cluster.name}"
    service_name = "${aws_ecs_service.api_fargate_service.name}"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${aws_alb_listener.fargate_alb.arn}"]
      }

      target_group {
        name = "${aws_alb_target_group.fargate_api_blue.name}"
      }

      target_group {
        name = "${aws_alb_target_group.fargate_api_green.name}"
      }
    }
  }
}
