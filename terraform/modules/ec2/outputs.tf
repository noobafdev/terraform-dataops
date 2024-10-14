output "instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = aws_instance.app.*.id
}

output "instance_private_ips" {
  description = "The private IPs of the EC2 instances"
  value       = aws_instance.app.*.private_ip
}

output "security_group_id" {
  description = "The security group ID used for the EC2 instances"
  value       = aws_security_group.app_sg.id
}
