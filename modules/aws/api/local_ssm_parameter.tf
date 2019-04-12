resource "aws_ssm_parameter" "local_api_cors_origin" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/CORS_ORIGIN"
  type      = "SecureString"
  value     = "${data.external.local_api.result["FRONTEND_URL"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_app_url" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/APP_URL"
  type      = "SecureString"
  value     = "${data.external.local_api.result["BACKEND_URL"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_app_key" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/APP_KEY"
  type      = "SecureString"
  value     = "${data.external.local_api.result["BACKEND_APP_KEY"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_db_password" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/DB_PASSWORD"
  type      = "SecureString"
  value     = "${data.external.local_api.result["DB_PASSWORD"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_slack_token" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/NOTIFICATION_SLACK_TOKEN"
  type      = "SecureString"
  value     = "${data.external.local_api.result["NOTIFICATION_SLACK_TOKEN"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_slack_channel" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/NOTIFICATION_SLACK_CHANNEL"
  type      = "SecureString"
  value     = "${data.external.local_api.result["NOTIFICATION_SLACK_CHANNEL"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_app_name" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/APP_NAME"
  type      = "String"
  value     = "qiita-stocker-backend"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_app_env" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/APP_ENV"
  type      = "String"
  value     = "local"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_app_debug" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/APP_DEBUG"
  type      = "String"
  value     = "true"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_log_channel" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/LOG_CHANNEL"
  type      = "String"
  value     = "app"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_db_connection" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/DB_CONNECTION"
  type      = "String"
  value     = "mysql"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_db_host" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/DB_HOST"
  type      = "String"
  value     = "mysql"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_db_port" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/DB_PORT"
  type      = "String"
  value     = "3306"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_db_database" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/DB_DATABASE"
  type      = "String"
  value     = "qiita_stocker"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_db_username" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/DB_USERNAME"
  type      = "String"
  value     = "qiita_stocker"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_broadcast_driver" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/BROADCAST_DRIVER"
  type      = "String"
  value     = "log"
  overwrite = true
}

resource "aws_ssm_parameter" "local_api_maintenance_mode" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  name      = "/local/qiita-stocker/api/MAINTENANCE_MODE"
  type      = "String"
  value     = "false"
  overwrite = true
}
