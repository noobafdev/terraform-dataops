variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "acl" {
  description = "The canned ACL to apply to the S3 bucket"
  type        = string
  default     = "private"
}

variable "enable_versioning" {
  description = "Whether to enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}
