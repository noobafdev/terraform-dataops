output "ec2_security_group_id" {
  description = "The ID of the security group for EC2 instances"
  value       = aws_security_group.ec2_sg.id
}

output "rds_security_group_id" {
  description = "The ID of the security group for RDS instances"
  value       = aws_security_group.rds_sg.id
}

# Update this to output all ALB security group IDs
output "alb_security_group_ids" {
  description = "The IDs of the security groups for the Application Load Balancer"
  value       = aws_security_group.alb_sg[*].id  # Output all security group IDs created with count
}
