variable "bucket" {
  type = "string"

  default = "qiita-stocker-frontend"
}

variable "main_domain_name" {
  type = "string"

  default = ""
}

variable "sub_domain_name" {
  type = "string"

  default = "www"
}

variable "acm" {
  type = "map"

  default = {}
}
