variable "environment" {
  description = "Environment name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "web_sg_id" {
  description = "Web tier security group ID"
  type        = string
}

variable "app_sg_id" {
  description = "App tier security group ID"
  type        = string
}

variable "web_subnet_ids" {
  description = "Web subnet IDs"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "App subnet IDs"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ALB security group ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}