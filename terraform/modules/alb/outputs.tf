# Output the DNS name of the ALB for external access
output "alb_dns_name" {
  value       = aws_lb.app_lb.dns_name
  description = "The DNS name of the Application Load Balancer"
}

# Output all Security Group IDs for the ALB (as a list)
output "alb_security_group_ids" {  # Use plural to indicate it's a list
  value       = aws_security_group.alb_sg[*].id  # Collect all SG IDs created with count
  description = "The security group IDs for the Application Load Balancer"
}

# Output the Target Group ARN for EC2 instances
output "target_group_arn" {
  value       = aws_lb_target_group.app_tg.arn
  description = "Target group ARN for attaching EC2 instances"
}
