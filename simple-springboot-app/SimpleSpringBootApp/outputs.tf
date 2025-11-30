output "ec2_public_ip" {
  value       = aws_instance.springboot.public_ip
  description = "Public IP of Spring Boot EC2 instance"
}

