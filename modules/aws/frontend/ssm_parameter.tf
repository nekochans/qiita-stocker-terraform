resource "aws_ssm_parameter" "frontend_api_url_base" {
  name      = "/${terraform.workspace}/qiita-stocker/frontend/API_URL_BASE"
  type      = "SecureString"
  value     = data.external.frontend.result["BACKEND_URL"]
  overwrite = true
}

resource "aws_ssm_parameter" "frontend_qiita_client_id" {
  name      = "/${terraform.workspace}/qiita-stocker/frontend/QIITA_CLIENT_ID"
  type      = "SecureString"
  value     = data.external.frontend.result["QIITA_CLIENT_ID"]
  overwrite = true
}

resource "aws_ssm_parameter" "frontend_qiita_client_secret" {
  name      = "/${terraform.workspace}/qiita-stocker/frontend/QIITA_CLIENT_SECRET"
  type      = "SecureString"
  value     = data.external.frontend.result["QIITA_CLIENT_SECRET"]
  overwrite = true
}

resource "aws_ssm_parameter" "frontend_qiita_redirect_uri" {
  name      = "/${terraform.workspace}/qiita-stocker/frontend/QIITA_REDIRECT_URI"
  type      = "SecureString"
  value     = data.external.frontend.result["QIITA_REDIRECT_URI"]
  overwrite = true
}

resource "aws_ssm_parameter" "frontend_tracking_id" {
  name      = "/${terraform.workspace}/qiita-stocker/frontend/TRACKING_ID"
  type      = "SecureString"
  value     = data.external.frontend.result["TRACKING_ID"]
  overwrite = true
}

resource "aws_ssm_parameter" "frontend_google_site_verification" {
  name      = "/${terraform.workspace}/qiita-stocker/frontend/GOOGLE_SITE_VERIFICATION"
  type      = "SecureString"
  value     = data.external.frontend.result["GOOGLE_SITE_VERIFICATION"]
  overwrite = true
}

resource "aws_ssm_parameter" "frontend_frontend_url" {
  name      = "/${terraform.workspace}/qiita-stocker/frontend/APP_URL"
  type      = "SecureString"
  value     = data.external.frontend.result["FRONTEND_URL"]
  overwrite = true
}

resource "aws_ssm_parameter" "frontend_app_stage" {
  name      = "/${terraform.workspace}/qiita-stocker/frontend/STAGE"
  type      = "String"
  value     = terraform.workspace
  overwrite = true
}
