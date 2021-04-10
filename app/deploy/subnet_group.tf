###### Provision Public, APP & Database  Subnet

#### Public Subnet 1

resource "aws_subnet" "pub_subnet_1" {

  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_pub_subnet_1_cidr
  tags = {
    Name = "Public Subnet 1"
  }
  availability_zone = var.az_zone_1
}

#### Public Subnet 2

resource "aws_subnet" "pub_subnet_2" {

  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_pub_subnet_2_cidr
  tags = {
    Name = "Public Subnet 2"
  }
  availability_zone = var.az_zone_2
}


#### APP Subnet 1

resource "aws_subnet" "app_subnet_1" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_app_subnet_1_cidr
  tags = {
    Name = "APP subnet 1"
  }
  availability_zone = var.az_zone_1
}


#### APP Subnet 2

resource "aws_subnet" "app_subnet_2" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_app_subnet_2_cidr
  tags = {
    Name = "APP subnet 2"
  }
  availability_zone = var.az_zone_2
}

#### DATABASE SUBNET 1

resource "aws_subnet" "db_subnet_1" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_db_subnet_1_cidr
  tags = {
    Name = "DB subnet 1"
  }
  availability_zone = var.az_zone_1
}

#### DATABASE SUBNET 2

resource "aws_subnet" "db_subnet_2" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_db_subnet_2_cidr
  tags = {
    Name = "DB subnet 2"
  }
  availability_zone = var.az_zone_2
}
