variable "ecs" {
  type = "map"

  default = {
    default.name = "prod-fargate-api"
    stg.name     = "stg-fargate-api"
    region       = "ap-northeast-1"
  }
}

data "aws_elb_service_account" "aws_elb_service_account" {}

variable "vpc" {
  type = "map"

  default = {}
}

variable "ecr" {
  type = "map"

  default = {}
}

variable "rds" {
  type = "map"

  default = {}
}

variable "main_domain_name" {
  type = "string"

  default = ""
}

variable "sub_domain_name" {
  type = "map"

  default = {
    stg.name     = "stg-fargate-api"
    default.name = "fargate-api"
  }
}

data "aws_acm_certificate" "main" {
  domain = "*.${var.main_domain_name}"
}
