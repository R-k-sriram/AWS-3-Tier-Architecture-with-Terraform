output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id 
}

output "web_alb_dns_name" {
  description = "Web tier ALB DNS name"
  value       = module.ec2_instances.web_alb_dns_name
}

output "app_alb_dns_name" {
  description = "App tier ALB DNS name"
  value       = module.ec2_instances.app_alb_dns_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.rds_endpoint
  sensitive   = true
}

output "web_instance_ips" {
  description = "Web tier instance private IPs"
  value       = module.ec2_instances.web_instance_ips
}

output "app_instance_ips" {
  description = "App tier instance private IPs"
  value       = module.ec2_instances.app_instance_ips
}