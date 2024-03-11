provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "fiap-tech-challenge-infra-db"
}

resource "aws_default_vpc" "default" {
    tags = {
        Name = "Default VPC"
    }
}

resource "aws_default_subnet" "def_subnet" {
    availability_zone = "us-east-2a"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "rds-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name: "subnet-a-rds-vpc"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name: "subnet-b-rds-vpc"
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-"

  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "db" {  

  storage_type           = "gp2"
  engine                 = "mysql"
  db_name                = "db"
  identifier             = "db"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  publicly_accessible    = true
  username             = "dbuser"
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true

  tags = {
    Name = "db"
  }
}
