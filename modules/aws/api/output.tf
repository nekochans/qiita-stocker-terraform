output "api" {
  value = "${
    map(
      "api_security_id", "${aws_security_group.api.id}"
    )
  }"
}
