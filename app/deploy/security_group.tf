##### APP Security Group

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

## SG ingress rule for Application Load balancer

resource "aws_security_group_rule" "app_lb_ingress_rule" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_asg.id
  source_security_group_id = aws_security_group.lb_asg.id
}


####LoadBalancer security group

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

### Database Security Group
resource "aws_security_group" "db" {
  name   = "Database Security Group"
  vpc_id = aws_vpc.app_vpc.id

  # Egress to everyone
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "DB SG"
  }
}

# Allow connection from APP Security Group
resource "aws_security_group_rule" "db_app_ingress_rule" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.app_asg.id
}

