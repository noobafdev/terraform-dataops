
# Terraform Infrastructure and FastAPI Application Setup

This guide explains how to set up AWS infrastructure and deploy a FastAPI application using Terraform and GitHub Actions.

## Overview

The setup provisions the following AWS resources:
- **VPC** with public and private subnets.
- **EC2 instance** in a private subnet.
- **RDS MySQL database**.
- **ALB** for API access.
- **S3 bucket** for storing application files.

**Why ALB and SSM?**
- **ALB** provides secure public access to the API while the EC2 instance remains private.
- **SSM** enables management and deployment of the application without SSH access.

## Setup Steps

### 1. Clone the Repository
```bash
git clone https://github.com/noobafdev/terraform-dataops.git
cd terraform-dataops/terraform
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Automatically Generate `terraform.tfvars`
You don’t need to manually create the `terraform.tfvars` file. It is generated automatically in the CI/CD pipeline with values from GitHub Secrets.

### 4. Deploy Infrastructure
```bash
terraform plan
terraform apply
```

### 5. Extract Terraform Outputs
Key outputs, such as `S3_BUCKET_NAME`, `ALB_DNS_NAME`, and `EC2_INSTANCE_ID`, are captured during the deployment process.

## FastAPI Application Deployment

The FastAPI application is zipped and uploaded to S3, and then deployed to the EC2 instance using SSM. Health checks are performed via the ALB.

### Testing the API
To manually test the API, use the ALB DNS name:
```bash
curl http://<alb-dns-name>
```
You should see a response like:
```json
{ "message": "Hello, World!" }
```

## Cost Optimization

- **Use smaller EC2 instances** for development (e.g., `t2.micro`).
- **Enable auto-scaling** for EC2 and RDS.
- **Use reserved instances** for RDS and lifecycle policies for S3 to save costs.