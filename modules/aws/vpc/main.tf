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
    Name = "${terraform.workspace}-igw"
  }
}

resource "aws_eip" "nat_ip_1a" {
  tags {
    Name = "${terraform.workspace}-nat-1a"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.public_1a", var.vpc["default.public_1a"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}a"

  tags {
    Name = "${terraform.workspace}-public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.public_1c", var.vpc["default.public_1c"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}c"

  tags {
    Name = "${terraform.workspace}-public-1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.public_1d", var.vpc["default.public_1d"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}d"

  tags {
    Name = "${terraform.workspace}-public-1d"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1a", var.vpc["default.private_1a"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}a"

  tags {
    Name = "${terraform.workspace}-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1c", var.vpc["default.private_1c"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}c"

  tags {
    Name = "${terraform.workspace}-private-1c"
  }
}

resource "aws_subnet" "private_1d" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${lookup(var.vpc, "${terraform.env}.private_1d", var.vpc["default.private_1d"])}"
  availability_zone = "${lookup(var.common, "${terraform.env}.region", var.common["default.region"])}d"

  tags {
    Name = "${terraform.workspace}-private-1d"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  allocation_id = "${aws_eip.nat_ip_1a.id}"
  subnet_id     = "${aws_subnet.public_1a.id}"

  tags {
    Name = "${terraform.workspace}-1a"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${terraform.workspace}-public-rt"
  }
}


resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_1a.id}"
  }

  tags {
    Name = "${terraform.workspace}-private-rt"
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
