provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "java_app" {
  ami           = "ami-0fa3fe0fa7920f68e" # Amazon Linux 2
  instance_type = "t3.small"
  key_name      = "Terraform" # apna AWS key pair yahan dalen

  provisioner "file" {
    source      = "../simple-java-app/target/simple-java-app-1.0-SNAPSHOT.jar"
    destination = "/home/ec2-user/simple-java-app.jar"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y java-1.8.0-openjdk",
      "java -jar /home/ec2-user/simple-java-app.jar > /home/ec2-user/app.log 2>&1 &"
    ]
  }

  tags = {
    Name = "TerraformJavaDeployer"
  }
}

