variable "private_subnet_ids" {
  description = "List of private subnet IDs where the RDS instance will be created"
  type        = list(string)
}

variable "allocated_storage" {
  description = "The amount of storage (in gigabytes) to allocate to the DB instance"
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "8.0.32"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "security_group_id" {
  description = "The security group ID for the RDS instance"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "multi_az" {
  description = "Whether to create a multi-AZ RDS instance"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "The storage type to be associated with the DB instance"
  type        = string
  default     = "gp2"
}

variable "backup_retention_period" {
  description = "The number of days to retain backups"
  type        = number
  default     = 7
}
