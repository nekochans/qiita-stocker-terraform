variable "bastion" {
  type = "map"

  default = {
    default.name          = "bastion"
    default.ami           = "ami-0d7ed3ddb85b521a6"
    default.instance_type = "t3.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "8"
  }
}

variable "vpc" {
  type = "map"

  default = {}
}

variable "ssh_public_key_path" {
  type = "string"

  default = ""
}
