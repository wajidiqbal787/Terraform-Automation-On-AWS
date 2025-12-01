provider "aws" {
  region = "us-east-1"
}

# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraform-python-automation-${random_id.bucket_id.hex}"
  acl    = "private"
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

# EC2 Instance
resource "aws_instance" "python_instance" {
  ami           = "ami-0fa3fe0fa7920f68e"
  instance_type = "t3.small"
  key_name      = "Jenkins"  # Your key pair

  vpc_security_group_ids = ["sg-0e6d594174be9ad9e"]  # Replace with your security group ID

  tags = {
    Name = "TerraformPythonS3Example"
  }

  # User data to install Python, boto3 and upload file to S3
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install python3 -y
              pip3 install boto3

              cat <<EOL > /home/ec2-user/upload_to_s3.py
              import boto3
              s3 = boto3.client('s3', region_name='us-east-1')
              bucket_name = '${aws_s3_bucket.my_bucket.bucket}'
              file_name = '/home/ec2-user/hello.txt'
              with open(file_name, 'w') as f:
                  f.write('Hello from Terraform + Python + S3!')
              s3.upload_file(file_name, bucket_name, 'hello.txt')
              print("File uploaded to S3 bucket:", bucket_name)
              EOL

              python3 /home/ec2-user/upload_to_s3.py
              EOF
}

