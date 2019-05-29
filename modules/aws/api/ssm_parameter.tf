resource "aws_ssm_parameter" "api_cors_origin" {
  name      = "/${terraform.workspace}/qiita-stocker/api/CORS_ORIGIN"
  type      = "SecureString"
  value     = "${data.external.api.result["FRONTEND_URL"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "api_app_url" {
  name      = "/${terraform.workspace}/qiita-stocker/api/APP_URL"
  type      = "SecureString"
  value     = "${data.external.api.result["BACKEND_URL"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "api_app_key" {
  name      = "/${terraform.workspace}/qiita-stocker/api/APP_KEY"
  type      = "SecureString"
  value     = "${data.external.api.result["BACKEND_APP_KEY"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "api_db_password" {
  name      = "/${terraform.workspace}/qiita-stocker/api/DB_PASSWORD"
  type      = "SecureString"
  value     = "${data.external.api.result["DB_PASSWORD"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "api_slack_token" {
  name      = "/${terraform.workspace}/qiita-stocker/api/NOTIFICATION_SLACK_TOKEN"
  type      = "SecureString"
  value     = "${data.external.api.result["NOTIFICATION_SLACK_TOKEN"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "api_slack_channel" {
  name      = "/${terraform.workspace}/qiita-stocker/api/NOTIFICATION_SLACK_CHANNEL"
  type      = "SecureString"
  value     = "${data.external.api.result["NOTIFICATION_SLACK_CHANNEL"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "api_datadog_api_key" {
  name      = "/${terraform.workspace}/qiita-stocker/api/DD_API_KEY"
  type      = "SecureString"
  value     = "${data.external.api.result["DATADOG_API_KEY"]}"
  overwrite = true
}

resource "aws_ssm_parameter" "api_app_name" {
  name      = "/${terraform.workspace}/qiita-stocker/api/APP_NAME"
  type      = "String"
  value     = "qiita-stocker-backend"
  overwrite = true
}

resource "aws_ssm_parameter" "api_app_env" {
  name      = "/${terraform.workspace}/qiita-stocker/api/APP_ENV"
  type      = "String"
  value     = "${terraform.workspace}"
  overwrite = true
}

resource "aws_ssm_parameter" "api_app_debug" {
  name      = "/${terraform.workspace}/qiita-stocker/api/APP_DEBUG"
  type      = "String"
  value     = "true"
  overwrite = true
}

resource "aws_ssm_parameter" "api_log_channel" {
  name      = "/${terraform.workspace}/qiita-stocker/api/LOG_CHANNEL"
  type      = "String"
  value     = "app"
  overwrite = true
}

resource "aws_ssm_parameter" "api_db_connection" {
  name      = "/${terraform.workspace}/qiita-stocker/api/DB_CONNECTION"
  type      = "String"
  value     = "mysql"
  overwrite = true
}

resource "aws_ssm_parameter" "api_db_host" {
  name      = "/${terraform.workspace}/qiita-stocker/api/DB_HOST"
  type      = "String"
  value     = "${var.rds_local_master_domain_name}.${terraform.workspace}"
  overwrite = true
}

resource "aws_ssm_parameter" "api_db_port" {
  name      = "/${terraform.workspace}/qiita-stocker/api/DB_PORT"
  type      = "String"
  value     = "3306"
  overwrite = true
}

resource "aws_ssm_parameter" "api_db_database" {
  name      = "/${terraform.workspace}/qiita-stocker/api/DB_DATABASE"
  type      = "String"
  value     = "qiita_stocker"
  overwrite = true
}

resource "aws_ssm_parameter" "api_db_username" {
  name      = "/${terraform.workspace}/qiita-stocker/api/DB_USERNAME"
  type      = "String"
  value     = "qiita_stocker"
  overwrite = true
}

resource "aws_ssm_parameter" "api_broadcast_driver" {
  name      = "/${terraform.workspace}/qiita-stocker/api/BROADCAST_DRIVER"
  type      = "String"
  value     = "log"
  overwrite = true
}

resource "aws_ssm_parameter" "api_maintenance_mode" {
  name      = "/${terraform.workspace}/qiita-stocker/api/MAINTENANCE_MODE"
  type      = "String"
  value     = "false"
  overwrite = true
}
