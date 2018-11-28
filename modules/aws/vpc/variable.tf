variable "vpc" {
  type = "map"

  default = {
    default.az_1a      = "ap-northeast-1a"
    default.az_1c      = "ap-northeast-1c"
    default.az_1d      = "ap-northeast-1d"
    default.name       = "prod_qiita_stocker_vpc"
    stg.name           = "stg_qiita_stocker_vpc"
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
