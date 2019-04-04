variable "vpc" {
  type = "map"

  default = {
    default.az_1a      = "ap-northeast-1a"
    default.az_1c      = "ap-northeast-1c"
    default.az_1d      = "ap-northeast-1d"
    default.name       = "prod-qiita-stocker-vpc"
    stg.name           = "stg-qiita-stocker-vpc"
    default.cidr       = "10.1.0.0/16"
    stg.cidr           = "10.3.0.0/16"
    default.public_1a  = "10.1.0.0/24"
    default.public_1c  = "10.1.1.0/24"
    default.public_1d  = "10.1.2.0/24"
    stg.public_1a      = "10.3.0.0/24"
    stg.public_1c      = "10.3.1.0/24"
    stg.public_1d      = "10.3.2.0/24"
    default.private_1a = "10.1.10.0/24"
    default.private_1c = "10.1.11.0/24"
    default.private_1d = "10.1.12.0/24"
    stg.private_1a     = "10.3.10.0/24"
    stg.private_1c     = "10.3.11.0/24"
    stg.private_1d     = "10.3.12.0/24"
  }
}

variable "nat_instance" {
  type = "map"

  default = {
    default.name          = "prod-nat"
    stg.name              = "stg-nat"
    default.ami           = "ami-00d29e4cb217ae06b"
    default.instance_type = "t2.micro"
    default.volume_type   = "gp2"
    default.volume_size   = "30"
  }
}

variable "ssh_public_key_path" {
  type = "string"

  default = ""
}
