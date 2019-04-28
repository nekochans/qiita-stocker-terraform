data "aws_secretsmanager_secret" "frontend" {
  name = "${terraform.workspace}/qiita-stocker"
}

data "aws_secretsmanager_secret_version" "frontend" {
  secret_id = "${data.aws_secretsmanager_secret.frontend.id}"
}

data "external" "frontend" {
  program = ["echo", "${data.aws_secretsmanager_secret_version.frontend.secret_string}"]
}

data "aws_secretsmanager_secret" "local_frontend" {
  count = "${terraform.workspace == "stg" ? 1 : 0}"
  name  = "local/qiita-stocker"
}

data "aws_secretsmanager_secret_version" "local_frontend" {
  count     = "${terraform.workspace == "stg" ? 1 : 0}"
  secret_id = "${data.aws_secretsmanager_secret.local_frontend.id}"
}

data "external" "local_frontend" {
  count   = "${terraform.workspace == "stg" ? 1 : 0}"
  program = ["echo", "${data.aws_secretsmanager_secret_version.local_frontend.secret_string}"]
}
