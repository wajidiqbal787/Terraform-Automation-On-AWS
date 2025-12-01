variable "aws_region" {
  description = "AWS region to deploy EC2 instance"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "Terraform-Automation-On-AWS"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Name of the SSH key in AWS"
  type        = string
  default     = "terraform-demo-key"
}

variable "public_key_path" {
  description = "Path to the public SSH key on local machine"
  type        = string
  default     = "~/.ssh/terraform_demo_key.pub"
}

variable "app_port" {
  description = "Port on which Node.js app will run"
  type        = number
  default     = 3000
}

variable "my_ip_cidr" {
  description = "Your IP CIDR for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}
