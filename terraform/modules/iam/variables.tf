variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket that EC2 instances need to access"
  type        = string
}

variable "secrets_arn" {
  description = "The ARN of the Secrets Manager secret containing database credentials"
  type        = string
}
