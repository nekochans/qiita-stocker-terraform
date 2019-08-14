resource "aws_security_group" "api_codebuild" {
  name        = "${terraform.workspace}-${lookup(var.api, "${terraform.workspace}.name", var.api["default.name"])}-codebuild"
  description = "Security Group to ${lookup(var.api, "${terraform.workspace}.name", var.api["default.name"])} codebuild"
  vpc_id      = var.vpc["vpc_id"]

  tags = {
    Name = "${terraform.workspace}-${lookup(var.api, "${terraform.workspace}.name", var.api["default.name"])}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_codebuild_project" "api_rds_migration" {
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "nekochans/laravel-build:0.2.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "CORS_ORIGIN"
      value = aws_ssm_parameter.api_cors_origin.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "APP_URL"
      value = aws_ssm_parameter.api_app_url.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "APP_KEY"
      value = aws_ssm_parameter.api_app_key.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DB_PASSWORD"
      value = aws_ssm_parameter.api_db_password.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "NOTIFICATION_SLACK_TOKEN"
      value = aws_ssm_parameter.api_slack_token.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "NOTIFICATION_SLACK_CHANNEL"
      value = aws_ssm_parameter.api_slack_channel.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "APP_NAME"
      value = aws_ssm_parameter.api_app_name.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "APP_ENV"
      value = aws_ssm_parameter.api_app_env.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "APP_DEBUG"
      value = aws_ssm_parameter.api_app_debug.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "LOG_CHANNEL"
      value = aws_ssm_parameter.api_log_channel.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DB_CONNECTION"
      value = aws_ssm_parameter.api_db_connection.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DB_HOST"
      value = aws_ssm_parameter.api_db_host.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DB_PORT"
      value = aws_ssm_parameter.api_db_port.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DB_DATABASE"
      value = aws_ssm_parameter.api_db_database.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DB_USERNAME"
      value = aws_ssm_parameter.api_db_username.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "BROADCAST_DRIVER"
      value = aws_ssm_parameter.api_broadcast_driver.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "MAINTENANCE_MODE"
      value = aws_ssm_parameter.api_maintenance_mode.name
      type  = "PARAMETER_STORE"
    }
  }

  name         = "${terraform.workspace}-${lookup(var.api, "${terraform.workspace}.name", var.api["default.name"])}-rds-migration"
  service_role = var.iam["codebuild_role_arn"]

  source {
    type            = "GITHUB"
    location        = "https://github.com/nekochans/qiita-stocker-backend.git"
    git_clone_depth = 1
    buildspec       = "buildspec-migration.yml"
  }

  vpc_config {
    security_group_ids = [aws_security_group.api_codebuild.id]

    subnets = [
      var.vpc["subnet_private_1a_id"],
      var.vpc["subnet_private_1c_id"],
    ]

    vpc_id = var.vpc["vpc_id"]
  }
}

data "aws_caller_identity" "current" {
}

resource "aws_codebuild_project" "push_to_ecr" {
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "DEPLOY_STAGE"
      value = terraform.workspace
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "REPOSITORY_NGINX"
      value = "${terraform.workspace}-api-nginx"
    }

    environment_variable {
      name  = "REPOSITORY_PHP"
      value = "${terraform.workspace}-api-php"
    }
  }

  name = "${lookup(
    var.fargate,
    "${terraform.workspace}.name",
    var.fargate["default.name"]
  )}-push-ecr"
  service_role = var.iam["codebuild_role_arn"]

  source {
    type                = "GITHUB"
    location            = "https://github.com/nekochans/qiita-stocker-backend.git"
    git_clone_depth     = 1
    buildspec           = "buildspec-push-ecr.yml"
    report_build_status = true
  }

  badge_enabled = true
}
