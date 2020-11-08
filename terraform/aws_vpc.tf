####################
# VPC
####################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "wp_dev_vpc"
  }
}

####################
# Subnet
####################
resource "aws_subnet" "sub_pub_1a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  //パブリック IPv4 アドレスの自動割り当て
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"

  tags = {
    Name = "wp_dev_sub_pub_1a"
  }
}

resource "aws_subnet" "sub_pub_1c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  //パブリック IPv4 アドレスの自動割り当て
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1c"

  tags = {
    Name = "wp_dev_sub_pub_1c"
  }
}

resource "aws_subnet" "sub_db_pri_1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "wp_dev_sub_db_pri_1a"
  }
}

resource "aws_subnet" "sub_db_pri_1c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "wp_dev_sub_db_pri_1c"
  }
}

####################
# DB Subnet
####################
resource "aws_db_subnet_group" "db_sub_gp" {
  name       = "dbsubnet"
  subnet_ids = [aws_subnet.sub_db_pri_1a.id, aws_subnet.sub_db_pri_1c.id]

  tags = {
    Name = "wp_dev_sub_gp"
  }
}

####################
# Internet Gateway
####################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "wp_dev_igw"
  }
}

####################
# Route Table
####################
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  //インターネットゲートウェイ向けのルート追加
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "wp_dev_pub_rt"
  }
}

resource "aws_route_table" "db_pri_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "wp_dev_db_pri_rt"
  }
}

####################
# Route Association
####################
resource "aws_route_table_association" "sub_pub_1a_rt_assocication" {
  subnet_id      = aws_subnet.sub_pub_1a.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "sub_pub_1c_rt_assocication" {
  subnet_id      = aws_subnet.sub_pub_1c.id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "sub_db_pri_1a_rt_assocication" {
  subnet_id      = aws_subnet.sub_db_pri_1a.id
  route_table_id = aws_route_table.db_pri_rt.id
}

resource "aws_route_table_association" "sub_db_pri_1c_rt_assocication" {
  subnet_id      = aws_subnet.sub_db_pri_1c.id
  route_table_id = aws_route_table.db_pri_rt.id
}
