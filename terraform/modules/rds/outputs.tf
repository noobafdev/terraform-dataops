output "db_instance_identifier" {
  description = "The identifier of the RDS instance"
  value       = aws_db_instance.main.id
}

output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.main.name
}
