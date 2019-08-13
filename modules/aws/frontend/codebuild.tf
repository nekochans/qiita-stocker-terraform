data "aws_iam_policy_document" "codebuild_trust_relationship" {
  count = terraform.workspace == "stg" ? 1 : 0

  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
        "codedeploy.amazonaws.com",
        "secretsmanager.amazonaws.com",
        "s3.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  count = terraform.workspace == "stg" ? 1 : 0

  name               = "${terraform.workspace}-frontend-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_trust_relationship[count.index].json
}

resource "aws_iam_role_policy_attachment" "attach_admin_access_to_codebuild_role" {
  count = terraform.workspace == "stg" ? 1 : 0

  role       = aws_iam_role.codebuild_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codebuild_project" "frontend" {
  count = terraform.workspace == "stg" ? 1 : 0

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:2.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "DEPLOY_STAGE"
      value = terraform.workspace
    }

    environment_variable {
      name  = "DISTRIBUTION_ID"
      value = aws_cloudfront_distribution.nuxt[count.index].id
    }

    environment_variable {
      name  = "QIITA_CLIENT_ID"
      value = aws_ssm_parameter.frontend_qiita_client_id.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "QIITA_CLIENT_SECRET"
      value = aws_ssm_parameter.frontend_qiita_client_secret.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "API_URL_BASE"
      value = aws_ssm_parameter.frontend_api_url_base.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "APP_URL"
      value = aws_ssm_parameter.frontend_frontend_url.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "GOOGLE_SITE_VERIFICATION"
      value = aws_ssm_parameter.frontend_google_site_verification.name
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "TRACKING_ID"
      value = aws_ssm_parameter.frontend_tracking_id.name
      type  = "PARAMETER_STORE"
    }
  }

  name         = "${terraform.workspace}-frontend"
  service_role = aws_iam_role.codebuild_role[count.index].arn

  source {
    type                = "GITHUB"
    location            = "https://github.com/nekochans/qiita-stocker-nuxt.git"
    git_clone_depth     = 1
    buildspec           = "buildspec.yml"
    report_build_status = true
  }

  badge_enabled = true
}
