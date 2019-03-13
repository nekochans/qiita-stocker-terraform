output "rds" {
  value = "${
    map(
      "rds_security_id", "${aws_security_group.rds_cluster.id}"
    )
  }"
}
