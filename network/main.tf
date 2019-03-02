provider "aws" {}

resource "aws_vpc" "my_first_aryan_vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    "Name" = "MyFirstAryanVPC"
  }
}

resource "aws_internet_gateway" "main_gw_aryan" {
  vpc_id = "${aws_vpc.my_first_aryan_vpc.id}"
  tags {
    "Name" = "AryanIGW"
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.cidr_sub_pub_list)}"
  vpc_id = "${aws_vpc.my_first_aryan_vpc.id}"
  cidr_block = "${element(var.cidr_sub_pub_list, count.index)}"
  availability_zone = "${element(var.availability_zone_list, count.index)}"
  map_public_ip_on_launch = true

  tags {
    "Name" = "AryanSN${count.index}"
  }
}

resource "aws_route_table" "rt_public_aryan" {
  vpc_id = "${aws_vpc.my_first_aryan_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main_gw_aryan.id}"
  }

  tags {
    "Name" = "RTPubAryan"
  }
}

resource "aws_route_table_association" "rt_public_assoc_aryan" {
  count = "${length(var.cidr_sub_pub_list)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt_public_aryan.id}"
}


resource "aws_nat_gateway" "nat_gateway_aryan" {
  count = "${length(var.cidr_sub_pub_list)}"
  allocation_id = "${element(aws_eip.public_elastic_ip_aryan.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"

  tags {
    "Name" = "NATAryan${count.index}"
  }
}

resource "aws_eip" "public_elastic_ip_aryan" {
  count = "${length(var.cidr_sub_pub_list)}"
  vpc = true

  tags {
    "Name" = "EIPAryan${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = "${length(var.cidr_sub_private_list)}"
  vpc_id = "${aws_vpc.my_first_aryan_vpc.id}"
  cidr_block = "${element(var.cidr_sub_private_list, count.index)}"
  availability_zone = "${element(var.availability_zone_list, count.index)}"

  tags {
    "Name" = "AryanPrivSN${count.index}"
  }
}

resource "aws_route_table" "rt_private_aryan" {
  count = "${length(var.cidr_sub_private_list)}"
  vpc_id = "${aws_vpc.my_first_aryan_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${element(aws_nat_gateway.nat_gateway_aryan.*.id, count.index)}"
  }

  tags {
    "Name" = "RTPrivateAryan"
  }
}

resource "aws_route_table_association" "rt" {
  count = "${length(var.cidr_sub_private_list)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.rt_public_aryan.*.id, count.index)}"
}