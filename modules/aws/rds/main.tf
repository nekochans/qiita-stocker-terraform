resource "aws_security_group" "rds_security" {
  name        = "${terraform.workspace}_${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}_cluster"
  description = "Security Group to ${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${terraform.workspace}_${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}_cluster"
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${lookup(var.api, "api_security_id")}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "rds_cluster_serverless" {
  cluster_identifier              = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-cluster"
  master_username                 = "${var.rds_master_username}"
  master_password                 = "${var.rds_master_password}"
  backup_retention_period         = 5
  preferred_backup_window         = "19:30-20:00"
  skip_final_snapshot             = true
  storage_encrypted               = false
  vpc_security_group_ids          = ["${aws_security_group.rds_security.id}"]
  preferred_maintenance_window    = "wed:20:15-wed:20:45"
  db_subnet_group_name            = "${aws_db_subnet_group.rds_subnet.name}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.database_cluster_parameter_group.name}"
  engine                          = "aurora"
  engine_mode                     = "serverless"

  scaling_configuration = [
    {
      auto_pause               = true
      max_capacity             = 64
      min_capacity             = 2
      seconds_until_auto_pause = 300
    },
  ]
}

resource "aws_db_subnet_group" "rds_subnet" {
  name        = "${terraform.workspace}_${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  description = "${terraform.workspace}_${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}_subnet_group"
  subnet_ids  = ["${var.vpc["subnet_private_1a_id"]}", "${var.vpc["subnet_private_1c_id"]}", "${var.vpc["subnet_private_1d_id"]}"]
}

resource "aws_rds_cluster_parameter_group" "database_cluster_parameter_group" {
  name        = "${terraform.workspace}-${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-cluster"
  family      = "aurora5.6"
  description = "Cluster parameter group for ${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_connection"
    value = "utf8mb4_bin"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_bin"
  }

  parameter {
    name         = "character-set-client-handshake"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }

  lifecycle {
    ignore_changes = ["*"]
  }
}

resource "aws_route53_zone" "rds_local_domain_name" {
  name    = "${terraform.workspace}"
  vpc_id  = "${lookup(var.vpc, "vpc_id")}"
  comment = "${terraform.workspace} RDS Local Domain"
}

resource "aws_route53_record" "rds_local_master_domain_name" {
  zone_id = "${aws_route53_zone.rds_local_domain_name.zone_id}"
  name    = "${var.rds_local_master_domain_name}"
  type    = "CNAME"

  ttl     = 300
  records = ["${aws_rds_cluster.rds_cluster_serverless.endpoint}"]
}
