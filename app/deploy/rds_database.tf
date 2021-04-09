
###### Provision RDS Postgres Database
# Create DB subnet group
resource "aws_db_subnet_group" "db_subnet" {
  name       = "app_db_subnet_group"
  subnet_ids = [aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id]
  tags = {
    Name = "App DB"
  }
}


# Database instance provisioning

resource "aws_db_instance" "app_db" {
  identifier                      = var.db_identifier
  instance_class                  = var.db_class
  allocated_storage               = 20
  engine                          = var.db_engine
  name                            = var.db_name
  password                        = random_password.password.result
  username                        = var.db_user
  engine_version                  = var.db_engine_version
  db_subnet_group_name            = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids          = [aws_security_group.db.id]
  storage_encrypted               = var.storage_encrypted
  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  backup_retention_period         = var.backup_retention_period
  skip_final_snapshot             = var.skip_final_snapshot
  deletion_protection             = var.deletion_protection
  multi_az                        = var.multi_az

  tags = {
    Name = "APP DB"

  }
}

# Save database values in SSM parameter store

resource "random_password" "password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  override_special = "_%$"
}

resource "aws_ssm_parameter" "db_username" {
  name        = "dbusername"
  description = "DB Username"
  type        = "SecureString"
  value       = var.db_user

  tags = {
    Name = "APP DB"
  }
}

resource "aws_ssm_parameter" "db_password" {
  name        = "dbpassword"
  description = "DB Password "
  type        = "SecureString"
  value       = random_password.password.result

  tags = {
    Name = "APP DB"
  }
}


resource "aws_ssm_parameter" "db_name" {
  name        = "dbname"
  description = "DB Name"
  type        = "SecureString"
  value       = var.db_name

  tags = {
    Name = "App DB"
  }
}

resource "aws_ssm_parameter" "db_hostname" {
  depends_on  = [aws_db_instance.app_db]
  name        = "dbhostname"
  description = "DB Hostname"
  type        = "SecureString"
  value       = aws_db_instance.app_db.address

  tags = {
    Name = "APP DB"
  }
}



#### DATABASE SUBNETS
resource "aws_subnet" "db_subnet_1" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_db_subnet_1_cidr
  tags = {
    Name = "DB subnet 1"
  }
  availability_zone = var.az_zone_1
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = var.aws_db_subnet_2_cidr
  tags = {
    Name = "DB subnet 2"
  }
  availability_zone = var.az_zone_2
}


### SECURITY GROUP
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
