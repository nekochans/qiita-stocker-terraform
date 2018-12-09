resource "aws_vpc" "vpc" {
  cidr_block           = "${lookup(var.vpc, "${terraform.env}.cidr", var.vpc["default.cidr"])}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${lookup(var.vpc, "${terraform.env}.name", var.vpc["default.name"])}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${terraform.workspace}_igw"
  }
}

resource "aws_eip" "nat_ip_1a" {
  tags {
    Name = "${terraform.workspace}_nat_1a"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.public_1a", var.vpc["default.public_1a"])}"
  availability_zone = "${lookup(var.vpc, "default.az_1a")}"

  tags {
    Name = "${terraform.workspace}_public_1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.public_1c", var.vpc["default.public_1c"])}"
  availability_zone = "${lookup(var.vpc, "default.az_1c")}"

  tags {
    Name = "${terraform.workspace}_public_1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.public_1d", var.vpc["default.public_1d"])}"
  availability_zone = "${lookup(var.vpc, "default.az_1d")}"

  tags {
    Name = "${terraform.workspace}_public_1d"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1a", var.vpc["default.private_1a"])}"
  availability_zone = "${lookup(var.vpc, "default.az_1a")}"

  tags {
    Name = "${terraform.workspace}_private_1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1c", var.vpc["default.private_1c"])}"
  availability_zone = "${lookup(var.vpc, "default.az_1c")}"

  tags {
    Name = "${terraform.workspace}_private_1c"
  }
}

resource "aws_subnet" "private_1d" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1d", var.vpc["default.private_1d"])}"
  availability_zone = "${lookup(var.vpc, "default.az_1d")}"

  tags {
    Name = "${terraform.workspace}_private_1d"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  allocation_id = "${aws_eip.nat_ip_1a.id}"
  subnet_id     = "${aws_subnet.public_1a.id}"

  tags {
    Name = "${terraform.workspace}_1a"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${terraform.workspace}_public_rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_1a.id}"
  }

  tags {
    Name = "${terraform.workspace}_private_rt"
  }
}

resource "aws_route_table_association" "public_1a" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_1a.id}"
}

resource "aws_route_table_association" "public_1c" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_1c.id}"
}

resource "aws_route_table_association" "public_1d" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id      = "${aws_subnet.public_1d.id}"
}

resource "aws_route_table_association" "private_1a" {
  route_table_id = "${aws_route_table.private.id}"
  subnet_id      = "${aws_subnet.private_1a.id}"
}

resource "aws_route_table_association" "private_1c" {
  route_table_id = "${aws_route_table.private.id}"
  subnet_id      = "${aws_subnet.private_1c.id}"
}

resource "aws_route_table_association" "private_1d" {
  route_table_id = "${aws_route_table.private.id}"
  subnet_id      = "${aws_subnet.private_1d.id}"
}

resource "aws_network_acl" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    action     = "allow"
    from_port  = 80
    protocol   = "tcp"
    rule_no    = 100
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action     = "allow"
    from_port  = 443
    protocol   = "tcp"
    rule_no    = 110
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action     = "allow"
    from_port  = 22
    protocol   = "tcp"
    rule_no    = 120
    to_port    = 22
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    action     = "allow"
    from_port  = 3389
    protocol   = "tcp"
    rule_no    = 130
    to_port    = 3389
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 1024
    protocol   = "tcp"
    rule_no    = 140
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 80
    protocol   = "tcp"
    rule_no    = 100
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 443
    protocol   = "tcp"
    rule_no    = 110
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 3306
    protocol   = "tcp"
    rule_no    = 120
    to_port    = 3306
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  egress {
    action     = "allow"
    from_port  = 1024
    protocol   = "tcp"
    rule_no    = 130
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 22
    protocol   = "tcp"
    rule_no    = 140
    to_port    = 22
    cidr_block = "0.0.0.0/0"
  }

  subnet_ids = [
    "${aws_subnet.public_1a.id}",
    "${aws_subnet.public_1c.id}",
    "${aws_subnet.public_1d.id}",
  ]

  tags {
    Name = "${terraform.workspace}_public"
  }
}

resource "aws_network_acl" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    action     = "allow"
    from_port  = 80
    protocol   = "tcp"
    rule_no    = 100
    to_port    = 80
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 443
    protocol   = "tcp"
    rule_no    = 110
    to_port    = 443
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 22
    protocol   = "tcp"
    rule_no    = 120
    to_port    = 22
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 3306
    protocol   = "tcp"
    rule_no    = 130
    to_port    = 3306
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 3389
    protocol   = "tcp"
    rule_no    = 140
    to_port    = 3389
    cidr_block = "${aws_vpc.vpc.cidr_block}"
  }

  ingress {
    action     = "allow"
    from_port  = 1024
    protocol   = "tcp"
    rule_no    = 150
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 80
    protocol   = "tcp"
    rule_no    = 100
    to_port    = 80
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 443
    protocol   = "tcp"
    rule_no    = 110
    to_port    = 443
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 1024
    protocol   = "tcp"
    rule_no    = 120
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    action     = "allow"
    from_port  = 22
    protocol   = "tcp"
    rule_no    = 130
    to_port    = 22
    cidr_block = "0.0.0.0/0"
  }

  subnet_ids = [
    "${aws_subnet.private_1a.id}",
    "${aws_subnet.private_1c.id}",
    "${aws_subnet.private_1d.id}",
  ]

  tags {
    Name = "${terraform.workspace}_private"
  }
}
