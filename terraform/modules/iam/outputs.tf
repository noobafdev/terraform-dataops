output "ec2_role_arn" {
  description = "The ARN of the IAM role for EC2 instances"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  description = "The name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "rds_role_arn" {
  description = "The ARN of the IAM role for RDS instances"
  value       = aws_iam_role.rds_role.arn
}
