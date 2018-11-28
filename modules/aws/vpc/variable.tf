variable "vpc" {
  type = "map"

  default = {
    default.name = "prod_qiita_stocker_vpc"
    stg.name     = "stg_qiita_stocker_vpc"
    default.cidr = "10.1.0.0/16"
    stg.cidr     = "10.3.0.0/16"
  }
}
