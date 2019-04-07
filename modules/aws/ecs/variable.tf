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

data "aws_elb_service_account" "aws_elb_service_account" {}

variable "vpc" {
  type = "map"

  default = {}
}

variable "bastion" {
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
    stg.name     = "stg-ecs-api"
    default.name = "ecs-api"
  }
}

data "aws_acm_certificate" "main" {
  domain = "*.${var.main_domain_name}"
}
