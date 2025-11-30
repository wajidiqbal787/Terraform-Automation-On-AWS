provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "springboot" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "SimpleSpringBootApp"
  }

  user_data = <<EOF
#!/bin/bash
yum update -y
amazon-linux-extras enable corretto17
yum install -y java-17-amazon-corretto git unzip

cd /home/ec2-user
git clone https://github.com/wajidiqbal787/Terraform-Automation-On-AWS.git

cd Terraform-Automation-On-AWS/simple-springboot-app/SimpleSpringBootApp
chmod +x mvnw

./mvnw clean package -DskipTests
nohup ./mvnw spring-boot:run > app.log 2>&1 &
EOF
}

