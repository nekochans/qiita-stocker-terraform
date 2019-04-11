variable "api" {
  type = "map"

  default = {
    default.project       = "qiita-stocker"
    default.name          = "api"
    default.ami           = "ami-0d7ed3ddb85b521a6"
    default.instance_type = "t2.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "30"
    default.deploy_bucket = "prod-qiita-stocker-api-deploy"
    stg.deploy_bucket     = "stg-qiita-stocker-api-deploy"
  }
}

variable "ecs" {
  type = "map"

  default = {
    default.name          = "prod-ecs-api"
    stg.name              = "stg-ecs-api"
    default.instance_type = "t2.micro"
    default.volume_size   = "30"
    default.volume_type   = "gp2"
    default.ami           = "ami-084cb340923dc7101"
  }
}

variable "vpc" {
  type = "map"

  default = {}
}

variable "bastion" {
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
    stg.name         = "stg-api"
    default.name     = "api"
    stg.ecs_name     = "stg-ecs-api"
    default.ecs_name = "ecs-api"
  }
}

data "aws_elb_service_account" "aws_elb_service_account" {}

data "aws_acm_certificate" "main" {
  domain = "*.${var.main_domain_name}"
}

variable "ecr" {
  type = "map"

  default = {}
}

variable "rds" {
  type = "map"

  default = {}
}
