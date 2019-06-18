variable "api" {
  type = map(string)

  default = {
    "default.project" = "qiita-stocker"
    "default.name"    = "api"
  }
}

variable "ecs" {
  type = map(string)

  default = {
    "default.name"          = "prod-ecs-api"
    "stg.name"              = "stg-ecs-api"
    "default.instance_type" = "t2.micro"
    "default.volume_size"   = "30"
    "default.volume_type"   = "gp2"
    "default.ami"           = "ami-084cb340923dc7101"
  }
}

variable "fargate" {
  type = map(string)

  default = {
    "default.name" = "prod-fargate-api"
    "stg.name"     = "stg-fargate-api"
    region         = "ap-northeast-1"
  }
}

variable "vpc" {
  type = map(string)

  default = {}
}

variable "bastion" {
  type = map(string)

  default = {}
}

variable "main_domain_name" {
  type = string

  default = ""
}

variable "sub_domain_name" {
  type = map(string)

  default = {
    "stg.name"             = "stg-api"
    "default.name"         = "api"
    "stg.ecs_name"         = "stg-ecs-api"
    "default.ecs_name"     = "ecs-api"
    "stg.fargate_name"     = "stg-fargate-api"
    "default.fargate_name" = "fargate-api"
  }
}

data "aws_elb_service_account" "aws_elb_service_account" {
}

data "aws_acm_certificate" "main" {
  domain = "*.${var.main_domain_name}"
}

variable "ecr" {
  type = map(string)

  default = {}
}

variable "rds_local_master_domain_name" {
  type = string

  default = ""
}
