data "aws_secretsmanager_secret" "api" {
  name = "${terraform.workspace}/qiita-stocker"
}

data "aws_secretsmanager_secret_version" "api" {
  secret_id = data.aws_secretsmanager_secret.api.id
}

data "external" "api" {
  program = ["echo", data.aws_secretsmanager_secret_version.api.secret_string]
}

data "aws_secretsmanager_secret" "local_api" {
  count = terraform.workspace == "stg" ? 1 : 0
  name  = "local/qiita-stocker"
}

data "aws_secretsmanager_secret_version" "local_api" {
  count     = terraform.workspace == "stg" ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.local_api[0].id
}

data "external" "local_api" {
  count   = terraform.workspace == "stg" ? 1 : 0
  program = ["echo", data.aws_secretsmanager_secret_version.local_api[0].secret_string]
}
