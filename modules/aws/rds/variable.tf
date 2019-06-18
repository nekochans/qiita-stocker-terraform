variable "rds" {
  type = map(string)

  default = {
    "default.name"           = "prod-database"
    "stg.name"               = "stg-database"
    "default.engine"         = "aurora-mysql"
    "default.engine_version" = "5.7.12"
    "default.instance_class" = "db.t2.small"
    "default.instance_count" = 1
  }
}

variable "rds_master_username" {
  type    = string
  default = ""
}

variable "rds_master_password" {
  type    = string
  default = ""
}

variable "rds_local_master_domain_name" {
  type    = string
  default = ""
}

variable "vpc" {
  type = map(string)

  default = {}
}

variable "api" {
  type = map(string)

  default = {}
}

variable "ecs_api" {
  type = map(string)

  default = {}
}
