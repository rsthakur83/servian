#Provision APP Subnet
resource "aws_subnet" "app_subnet_1" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_app_subnet_1_cidr
  tags = {
    Name = "APP subnet 1"
  }
  availability_zone = var.az_zone_1
}


resource "aws_subnet" "app_subnet_2" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_app_subnet_2_cidr
  tags = {
    Name = "APP subnet 2"
  }
  availability_zone = var.az_zone_2
}

# Route Table with NAT gateway
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



# Route Table Association with APP subnet

resource "aws_route_table_association" "app-subnet1-routes" {
  subnet_id      = aws_subnet.app_subnet_1.id
  route_table_id = aws_route_table.app-subnet-routes.id
}

resource "aws_route_table_association" "app-subnet2-routes" {
  subnet_id      = aws_subnet.app_subnet_2.id
  route_table_id = aws_route_table.app-subnet-routes-2.id
}


# Public Subnet Groups required by load balancer

resource "aws_subnet" "pub_subnet_1" {

  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_pub_subnet_1_cidr
  tags = {
    Name = "Public Subnet 1"
  }
  availability_zone = var.az_zone_1
}

resource "aws_subnet" "pub_subnet_2" {

  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_pub_subnet_2_cidr
  tags = {
    Name = "Public Subnet 2"
  }
  availability_zone = var.az_zone_2
}


# Route with internet gateway attached

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

# Route table association with Public Subnet
resource "aws_route_table_association" "public-subnet-routes-1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.public-routes.id
}

resource "aws_route_table_association" "public-subnet-routes-2" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.public-routes.id
}

# NAT Gateway configuration for private subnets
resource "aws_eip" "nat-eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.app_igw", "aws_vpc_dhcp_options_association.dns_resolver"]
  tags = {
    Name = "Nat Gateway EIP"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.pub_subnet_1.id
  depends_on    = ["aws_internet_gateway.app_igw"]
  tags = {
    Name = "Nat Gateway"
  }
}

resource "aws_eip" "nat-eip-2" {
  vpc        = true
  depends_on = ["aws_internet_gateway.app_igw", "aws_vpc_dhcp_options_association.dns_resolver"]
  tags = {
    Name = "Nat Gateway EIP 2"
  }
}

resource "aws_nat_gateway" "nat-gw1" {
  allocation_id = aws_eip.nat-eip-2.id
  subnet_id     = aws_subnet.pub_subnet_2.id
  depends_on    = ["aws_internet_gateway.app_igw"]
  tags = {
    Name = "Nat Gateway 2"
  }
}


#APP Security Group

resource "aws_security_group" "app_asg" {
  name        = "APP Security Group"
  description = "Allow HTTP from Load Balancer"
  vpc_id      = aws_vpc.app_vpc.id


  egress {
    from_port   = 0 # need to address
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "APP SG"
  }

}


resource "aws_security_group_rule" "app_lb_ingress_rule" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_asg.id
  source_security_group_id = aws_security_group.lb_asg.id
}


#LoadBalancer sg

resource "aws_security_group" "lb_asg" {
  name        = "ALB Security Group"
  description = "Allow HTTP  Traffic from Internet to Load Balancer"
  vpc_id      = aws_vpc.app_vpc.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB SG"
  }

}
