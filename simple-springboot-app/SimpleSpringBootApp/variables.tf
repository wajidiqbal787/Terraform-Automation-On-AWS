variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  default     = "ami-0fa3fe0fa7920f68e" # Amazon Linux 2
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "key_name" {
  description = "Your AWS key pair name"
  default     = "Jenkins" # Change according to your key pair
}

