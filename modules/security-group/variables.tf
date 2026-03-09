variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "web_subnet_cidrs" {
  description = "Web subnet CIDR blocks"
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "App subnet CIDR blocks"
  type        = list(string)
}