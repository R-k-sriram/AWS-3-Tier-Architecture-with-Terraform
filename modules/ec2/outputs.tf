output "web_alb_dns_name" {
  description = "Web tier ALB DNS name"
  value       = aws_lb.web.dns_name
}

output "app_alb_dns_name" {
  description = "App tier ALB DNS name"
  value       = aws_lb.app.dns_name
}

output "web_instance_ids" {
  description = "Web tier instance IDs"
  value       = aws_instance.web[*].id
}

output "web_instance_ips" {
  description = "Web tier instance private IPs"
  value       = aws_instance.web[*].private_ip
}

output "web_instance_public_ips" {
  description = "Web tier instance public IPs"
  value       = aws_instance.web[*].public_ip
}

output "app_instance_ids" {
  description = "App tier instance IDs"
  value       = aws_instance.app[*].id
}

output "app_instance_ips" {
  description = "App tier instance private IPs"
  value       = aws_instance.app[*].private_ip
}