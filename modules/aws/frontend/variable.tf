variable "bucket_nuxt" {
  type = string

  default = "qiita-stocker-nuxt"
}

variable "api_gateway" {
  type = string

  default = "qiita-stocker-nuxt"
}

variable "main_domain_name" {
  type = string

  default = ""
}

variable "sub_domain_name" {
  type = map(string)

  default = {
    "stg.name"     = "stg-www"
    "default.name" = "www"
  }
}

variable "acm" {
  type = map(string)

  default = {}
}

variable "iam" {
  type = map(string)

  default = {}
}
