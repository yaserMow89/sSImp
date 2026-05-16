output "alb" {
  value       = aws_lb.example.dns_name
  description = "PUBLIC DNS NAME"
}

output "asg_name" {
  value       = aws_autoscaling_group.example.name
  description = "The name of the ASG"
}
output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "ID for the security group attached to the lb"
}
