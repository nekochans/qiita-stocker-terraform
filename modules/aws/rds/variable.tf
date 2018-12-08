variable "rds" {
  type = "map"

  default = {
    default.name = "database"
  }
}

variable "rds_master_username" {
  type    = "string"
  default = ""
}

variable "rds_master_password" {
  type    = "string"
  default = ""
}

variable "rds_local_master_domain_name" {
  type    = "string"
  default = ""
}

variable "vpc" {
  type = "map"

  default = {}
}

variable "api" {
  type = "map"

  default = {}
}
