terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = data.aws_region.current.name
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = false
}

resource "aws_db_instance" "db_instance" {
  allocated_storage      = 10
  db_name                = "cint_demo_db"
  engine                 = "mysql"
  engine_version         = "8.0"
  identifier             = "cint-rds-demo"
  db_subnet_group_name   = aws_db_subnet_group.default.id
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = random_password.password.result
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.private.ids
}