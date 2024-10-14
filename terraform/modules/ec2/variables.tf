variable "ami_id" {
  description = "AMI ID to use for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t2.micro"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where EC2 instances will be created"
  type        = list(string)
}

variable "instance_count" {
  description = "The number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for the EC2 instances"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to attach to the EC2 instances"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the EC2 instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-default-bucket-name"
}

variable "db_credentials_arn" {
  description = "ARN for the Secrets Manager database credentials"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN for ALB"
  type        = string
}

# Update this variable to handle multiple ALB security group IDs
variable "alb_security_group_ids" {
  description = "List of Security Group IDs for the Application Load Balancer"
  type        = list(string)  # Change to a list of strings to accept multiple IDs
}
