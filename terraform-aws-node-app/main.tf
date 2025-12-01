terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# Find latest Amazon Linux 2023 AMI (Not used because you hardcoded AMI)
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

# Key Pair
resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and App Port"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "App Port"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami                         = "ami-0fa3fe0fa7920f68e"
  instance_type               = "t3.small"
  key_name                    = var.key_name
  vpc_security_group_ids      = ["sg-0e6d594174be9ad9e"]
  associate_public_ip_address = true

  user_data = <<-USERDATA
              #!/bin/bash
              dnf update -y

              # Install Git
              dnf install -y git

              # Install Node.js 18
              dnf module enable nodejs:18 -y
              dnf install -y nodejs

              cd /home/ec2-user
              if [ -d app ]; then rm -rf app; fi

              # Clone repo
              git clone https://github.com/wajidiqbal787/Terraform-Automation-On-AWS.git app

              cd app || exit

              # Install dependencies
              if [ -f package.json ]; then
                npm install
                nohup npm start >/tmp/node-app.log 2>&1 &
              else
                echo "console.log('simple server running');" > server.js
                nohup node server.js >/tmp/node-app.log 2>&1 &
              fi
              USERDATA

  tags = {
    Name = var.project_name
  }
}

output "public_ip" {
  value = aws_instance.app.public_ip
}
