output "vpc" {
  value = "${
    map(
      "vpc_id", "${aws_vpc.vpc.id}",
      "subnet_public_1a_id", "${aws_subnet.public_1a.id}",
      "subnet_public_1c_id", "${aws_subnet.public_1c.id}",
      "subnet_public_1d_id", "${aws_subnet.public_1d.id}"
    )
  }"
}
