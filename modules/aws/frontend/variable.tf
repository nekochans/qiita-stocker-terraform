variable "bucket" {
  type = "string"

  default = "qiita-stocker-frontend"
}

variable "main_domain_name" {
  type = "string"

  default = ""
}

variable "sub_domain_name" {
  type = "map"

  default = {
    stg.name     = "stg-www"
    default.name = "www"
  }
}

variable "acm" {
  type = "map"

  default = {}
}
