resource "aws_security_group" "rds_cluster" {
  name        = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  description = "Security Group to ${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  vpc_id      = "${lookup(var.vpc, "vpc_id")}"

  tags {
    Name = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "rds_from_api_server" {
  security_group_id        = "${aws_security_group.rds_cluster.id}"
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = "${lookup(var.api, "api_security_id")}"
}

resource "aws_security_group_rule" "rds_from_api_codebuild" {
  security_group_id        = "${aws_security_group.rds_cluster.id}"
  type                     = "ingress"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
  source_security_group_id = "${lookup(var.api, "api_codebuild_security_id")}"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  description = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-subnet-group"

  subnet_ids = [
    "${var.vpc["subnet_private_1a_id"]}",
    "${var.vpc["subnet_private_1c_id"]}",
    "${var.vpc["subnet_private_1d_id"]}",
  ]
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name   = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}"
  family = "aurora-mysql5.7"

  description = "Database parameter group"

  parameter {
    name  = "long_query_time"
    value = "0.1"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {
  name        = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-cluster"
  family      = "aurora-mysql5.7"
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
    value = "binary"
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

resource "aws_rds_cluster" "rds_cluster" {
  cluster_identifier              = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-cluster"
  master_username                 = "${var.rds_master_username}"
  master_password                 = "${var.rds_master_password}"
  backup_retention_period         = 5
  preferred_backup_window         = "19:30-20:00"
  skip_final_snapshot             = true
  storage_encrypted               = false
  vpc_security_group_ids          = ["${aws_security_group.rds_cluster.id}"]
  preferred_maintenance_window    = "wed:20:15-wed:20:45"
  db_subnet_group_name            = "${aws_db_subnet_group.rds_subnet_group.name}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.rds_cluster_parameter_group.name}"
  engine                          = "${lookup(var.rds, "${terraform.env}.engine", var.rds["default.engine"])}"
  engine_version                  = "${lookup(var.rds, "${terraform.env}.engine_version", var.rds["default.engine_version"])}"
}

resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  count                   = "${lookup(var.rds, "${terraform.env}.instance_count", var.rds["default.instance_count"])}"
  cluster_identifier      = "${aws_rds_cluster.rds_cluster.id}"
  instance_class          = "${lookup(var.rds, "${terraform.env}.instance_class", var.rds["default.instance_class"])}"
  engine                  = "${lookup(var.rds, "${terraform.env}.engine", var.rds["default.engine"])}"
  engine_version          = "${lookup(var.rds, "${terraform.env}.engine_version", var.rds["default.engine_version"])}"
  identifier              = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-${count.index}"
  db_subnet_group_name    = "${aws_db_subnet_group.rds_subnet_group.name}"
  db_parameter_group_name = "${aws_db_parameter_group.rds_parameter_group.name}"
  monitoring_role_arn     = "${aws_iam_role.rds_monitoring.arn}"
  monitoring_interval     = 60

  tags {
    Name = "${lookup(var.rds, "${terraform.env}.name", var.rds["default.name"])}-${count.index}"
  }
}

resource "aws_route53_zone" "rds_local_domain_name" {
  name = "${terraform.workspace}"

  vpc {
    vpc_id = "${lookup(var.vpc, "vpc_id")}"
  }

  comment = "${terraform.workspace} RDS Local Domain"
}

resource "aws_route53_record" "rds_local_master_domain_name" {
  zone_id = "${aws_route53_zone.rds_local_domain_name.zone_id}"
  name    = "${var.rds_local_master_domain_name}"
  type    = "CNAME"

  ttl     = 300
  records = ["${aws_rds_cluster.rds_cluster.endpoint}"]
}
