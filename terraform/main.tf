
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------
# GET DEFAULT VPC
# ------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

# ------------------------------------------------
# FIND EXISTING INTERNET GATEWAY
# ------------------------------------------------

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ------------------------------------------------
# FIND LATEST AMAZON LINUX 2023 AMI
# ------------------------------------------------

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ------------------------------------------------
# CREATE NEW PUBLIC SUBNET
# ------------------------------------------------

resource "aws_subnet" "taskflow_public" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "TaskFlow-Public-Subnet"
    Type = "Public"
  }
}

# ------------------------------------------------
# CREATE PUBLIC ROUTE TABLE
# ------------------------------------------------

resource "aws_route_table" "taskflow_public_rt" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "TaskFlow-Public-Route-Table"
  }
}

# ------------------------------------------------
# ASSOCIATE ROUTE TABLE WITH PUBLIC SUBNET
# ------------------------------------------------

resource "aws_route_table_association" "taskflow_public_association" {
  subnet_id      = aws_subnet.taskflow_public.id
  route_table_id = aws_route_table.taskflow_public_rt.id
}

# ------------------------------------------------
# CREATE SECURITY GROUP
# ------------------------------------------------

resource "aws_security_group" "taskflow_sg" {
  name        = "taskflow-security-group"
  description = "Security group for TaskFlow application"
  vpc_id      = data.aws_vpc.default.id

  # SSH access
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  # Flask application access
  ingress {
    description = "TaskFlow application"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TaskFlow-Security-Group"
  }
}

# ------------------------------------------------
# CREATE EC2 INSTANCE
# ------------------------------------------------

resource "aws_instance" "taskflow_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.taskflow_public.id

  vpc_security_group_ids = [aws_security_group.taskflow_sg.id]

  key_name = var.key_name

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y python3 git
  EOF

  depends_on = [
    aws_route_table_association.taskflow_public_association
  ]

  tags = {
    Name        = "TaskFlow-Server"
    Environment = "Assignment"
  }
}
