variable "bastion" {
  type = "map"

  default = {
    default.name          = "bastion"
    default.ami           = "ami-e99f4896"
    default.instance_type = "t2.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "30"
  }
}

variable "vpc" {
  type = "map"

  default = {
  }
}
