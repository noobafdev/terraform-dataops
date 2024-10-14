# backend.tf

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-test3"  # Replace with your S3 bucket name for storing the state
    key            = "terraform/state"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"  # Replace with your DynamoDB table name for state locking
  }
}
