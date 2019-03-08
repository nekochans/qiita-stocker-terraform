variable "ecs" {
  type = "map"

  default = {
    default.name          = "prod-ecs-api"
    stg.name              = "stg-ecs-api"
    region                = "ap-northeast-1"
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

variable "ecr" {
  type = "map"

  default = {}
}

variable "rds" {
  type = "map"

  default = {}
}