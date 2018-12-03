variable "api" {
  type = "map"

  default = {
    default.project       = "qiita-stocker"
    default.name          = "api"
    default.ami           = "ami-00f9d04b3b3092052"
    default.instance_type = "t2.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "8"
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

data "aws_elb_service_account" "aws_elb_service_account" {}
