output "vpc" {
  value = "${
    map(
      "vpc_id", "${aws_vpc.vpc.id}",
      "subnet_public_1a_id", "${aws_subnet.public_1a.id}"
    )
  }"
}
