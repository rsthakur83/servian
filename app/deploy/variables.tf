variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}


variable "az_zone_1" {
  description = "Availability Zone"
  default     = "us-east-1a"
}

variable "az_zone_2" {
  description = "Availability Zone"
  default     = "us-east-1b"
}

variable "instance-type" {
  description = "Instance Type"
  default     = "t2.micro"
}

variable "image_id" {
  description = "Image id"
  default     = "ami-042e8287309f5df03" // us-east-1
//  default     = "ami-08962a4068733a2b6" // us-east-2
}


variable "aws_network_cidr" {
  description = "Network CIDR"
  default     = "10.0.0.0/16"
}

variable "aws_db_subnet_1_cidr" {
  description = "RDS Private CIDR"
  default     = "10.0.1.0/24"
}

variable "aws_db_subnet_2_cidr" {
  description = "RDS Private CIDR"
  default     = "10.0.2.0/24"
}

variable "aws_app_subnet_1_cidr" {
  description = "App Private CIDR"
  default     = "10.0.3.0/24"
}

variable "aws_app_subnet_2_cidr" {
  description = "App Private CIDR"
  default     = "10.0.4.0/24"
}


variable "aws_pub_subnet_1_cidr" {
  description = "Public CIDR"
  default     = "10.0.5.0/24"
}

variable "aws_pub_subnet_2_cidr" {
  description = "Public CIDR"
  default     = "10.0.6.0/24"
}


variable "db_class" {
  description = "Instance Type"
  default     = "db.t3.micro"
}

variable "db_user" {
  description = "Database user"
  default     = "app"
}

variable "db_name" {
  description = "Database name"
  default     = "app"
}

variable "db_engine" {
  description = "Database engine type"
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  default     = "10.7"
}

variable "db_identifier" {
  description = "Database Identifier"
  default     = "app-db"
}

variable "storage_encrypted" {
  description = "DB storage encryption"
  default     = "true"
}

variable "maintenance_window" {
  description = "Maintance Window"
  default     = "Sun:00:00-Sun:03:00"
}

variable "backup_window" {
  description = "Backup Window"
  default     = "03:00-06:00"

}
variable "enabled_cloudwatch_logs_exports" {
  description = "DB Cloudwatch logging"
  default     = ["postgresql", "upgrade"]

}
variable "backup_retention_period" {
  description = "DB backup retention"
  default     = 1

}

variable "skip_final_snapshot" {
  description = "DB snapshot"
  default     = "true"

}
variable "deletion_protection" {
  description = "DB deletion protection"
  default     = "false"

}
variable "multi_az" {
  description = "DB high availability"
  default     = "true"
}
