resource "aws_ssm_parameter" "local_frontend_app_url" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/frontend/VUE_APP_API_URL_BASE"
  type      = "SecureString"
  value     = "${data.external.local_frontend.result["BACKEND_URL"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_frontend_qiita_client_id" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/frontend/VUE_APP_QIITA_CLIENT_ID"
  type      = "SecureString"
  value     = "${data.external.local_frontend.result["QIITA_CLIENT_ID"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_frontend_qiita_client_secret" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/frontend/VUE_APP_QIITA_CLIENT_SECRET"
  type      = "SecureString"
  value     = "${data.external.local_frontend.result["QIITA_CLIENT_SECRET"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_frontend_qiita_redirect_uri" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/frontend/VUE_APP_QIITA_REDIRECT_URI"
  type      = "SecureString"
  value     = "${data.external.local_frontend.result["QIITA_REDIRECT_URI"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_frontend_tracking_id" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/frontend/VUE_APP_TRACKING_ID"
  type      = "SecureString"
  value     = "${data.external.local_frontend.result["TRACKING_ID"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_frontend_google_site_verification" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/frontend/VUE_APP_GOOGLE_SITE_VERIFICATION"
  type      = "SecureString"
  value     = "${data.external.local_frontend.result["GOOGLE_SITE_VERIFICATION"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_frontend_app_stage" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/frontend/VUE_APP_STAGE"
  type      = "String"
  value     = "local"
  overwrite = true
}
