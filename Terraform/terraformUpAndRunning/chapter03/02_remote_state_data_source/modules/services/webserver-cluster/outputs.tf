output "alb" {
  value       = aws_lb.example.dns_name
  description = "PUBLIC DNS NAME"
}
