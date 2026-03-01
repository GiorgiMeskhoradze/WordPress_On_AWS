resource "aws_vpc" "this_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.this_vpc.id
  for_each                = var.public_subnets
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    "Name" = "Public-Subnets-${each.key}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.this_vpc.id
  for_each                = var.private_subnets
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    "Name" = "Private-Subnets-${each.key}"
  }
}

resource "aws_internet_gateway" "aws_igw" {
  vpc_id = aws_vpc.this_vpc.id

  tags = {
    "Name" = "Internet-Gateway"
  }
}

resource "aws_eip" "aws_eip_nat" {
  domain = "vpc"

  tags = {
    "Name" = "EIP-for-NAT"
  }
}

resource "aws_nat_gateway" "aws_nat_gw" {
  allocation_id = aws_eip.aws_eip_nat.id
  subnet_id     = values(aws_subnet.public_subnets)[0].id
  depends_on    = [aws_internet_gateway.aws_igw]

  tags = {
    "Name" = "AWS-NAT-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_igw.id
  }

  tags = {
    "Name" = "Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_table_association" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this_vpc.id

  tags = {
    "Name" = "Private_Route_Table"
  }
}

resource "aws_route_table_association" "private_table_association" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private_subnets[each.key].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws_nat_gw.id
}