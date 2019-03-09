resource "aws_ecr_repository" "php" {
  count = "${terraform.workspace != "prod" ? 1 : 0}"
  name  = "${terraform.workspace}-api-php"
}

resource "aws_ecr_repository" "nginx" {
  count = "${terraform.workspace != "prod" ? 1 : 0}"
  name  = "${terraform.workspace}-api-nginx"
}

locals {
  lifecycle_policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 10,
        "description": "Expire images count more than 5",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 5
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}

resource "aws_ecr_lifecycle_policy" "php" {
  count      = "${terraform.workspace != "prod" ? 1 : 0}"
  repository = "${aws_ecr_repository.php.name}"
  policy     = "${local.lifecycle_policy}"
}

resource "aws_ecr_lifecycle_policy" "nginx" {
  count      = "${terraform.workspace != "prod" ? 1 : 0}"
  repository = "${aws_ecr_repository.nginx.name}"
  policy     = "${local.lifecycle_policy}"
}
