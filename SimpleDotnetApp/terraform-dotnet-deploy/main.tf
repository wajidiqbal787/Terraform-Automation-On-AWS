resource "aws_instance" "dotnet_ec2" {
  ami                    = "ami-0fa3fe0fa7920f68e"
  instance_type          = "t3.small"
  key_name               = "Terraform"                # existing key pair
  vpc_security_group_ids = ["sg-0e6d594174be9ad9e"]   # existing SG ID

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable docker
              yum install docker -y
              service docker start
              usermod -a -G docker ec2-user
              $(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 366932332706.dkr.ecr.us-east-1.amazonaws.com)
              docker run -d -p 80:80 366932332706.dkr.ecr.us-east-1.amazonaws.com/simple-dotnet-app:latest
              EOF

  tags = {
    Name = "DotnetAppEC2"
  }
}
