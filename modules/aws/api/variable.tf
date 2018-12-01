variable "api" {
  type = "map"

  default = {
    default.name          = "api"
    default.ami           = "ami-00f9d04b3b3092052"
    default.instance_type = "t3.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "8"
  }
}

variable "vpc" {
  type = "map"

  default = {}
}

variable "bastion_security_id" {
  type = "string"

  default = ""
}
