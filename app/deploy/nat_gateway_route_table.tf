##### EIP for NAT Gateway 1
resource "aws_eip" "nat-eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.app_igw", "aws_vpc_dhcp_options_association.dns_resolver"]
  tags = {
    Name = "Nat Gateway EIP"
  }
}


##### NAT Gateway 1 configuration for private subnets
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.pub_subnet_1.id
  depends_on    = ["aws_internet_gateway.app_igw"]
  tags = {
    Name = "Nat Gateway 1"
  }
}

##### EIP for NAT Gateway 2
resource "aws_eip" "nat-eip-2" {
  vpc        = true
  depends_on = ["aws_internet_gateway.app_igw", "aws_vpc_dhcp_options_association.dns_resolver"]
  tags = {
    Name = "Nat Gateway EIP 2"
  }
}

##### NAT Gateway 2 configuration for private subnets
resource "aws_nat_gateway" "nat-gw1" {
  allocation_id = aws_eip.nat-eip-2.id
  subnet_id     = aws_subnet.pub_subnet_2.id
  depends_on    = ["aws_internet_gateway.app_igw"]
  tags = {
    Name = "Nat Gateway 2"
  }
}

##### Route Table with NAT gateway 1
resource "aws_route_table" "app-subnet-routes" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "RT NAT Gateway 1"
  }
}

##### Route Table with NAT gateway 2

resource "aws_route_table" "app-subnet-routes-2" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw1.id
  }

  tags = {
    Name = "RT NAT Gateway 2"
  }
}

##### Route Table Association with APP subnet 1

resource "aws_route_table_association" "app-subnet1-routes" {
  subnet_id      = aws_subnet.app_subnet_1.id
  route_table_id = aws_route_table.app-subnet-routes.id
}

##### Route Table Association with APP subnet 2

resource "aws_route_table_association" "app-subnet2-routes" {
  subnet_id      = aws_subnet.app_subnet_2.id
  route_table_id = aws_route_table.app-subnet-routes-2.id
}

##### Route table association with Public Subnet 1

resource "aws_route_table_association" "public-subnet-routes-1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.public-routes.id
}

##### Route table association with Public Subnet 2

resource "aws_route_table_association" "public-subnet-routes-2" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.public-routes.id
}

##### Route with internet gateway attached

resource "aws_route_table" "public-routes" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }
  tags = {
    Name = "RT Internet Gateway"
  }
}
