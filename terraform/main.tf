# main.tf


module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "security_groups" {
  source                  = "./modules/security_groups"
  vpc_id                  = module.vpc.vpc_id
  environment             = var.environment
  allowed_ssh_cidr_blocks = var.allowed_ssh_cidr_blocks
  allowed_http_cidr_blocks = var.allowed_http_cidr_blocks
}

module "iam" {
  source           = "./modules/iam"
  environment      = var.environment
  s3_bucket_arn    = module.s3.bucket_arn
  secrets_arn      = var.db_credentials_arn
}

module "s3" {
  source             = "./modules/s3"
  bucket_name        = var.s3_bucket_name
  acl                = var.s3_acl
  enable_versioning  = var.enable_versioning
  environment        = var.environment
}

module "rds" {
  source                   = "./modules/rds"
  private_subnet_ids       = module.vpc.private_subnet_ids
  allocated_storage        = var.rds_allocated_storage
  engine_version           = var.rds_engine_version
  instance_class           = var.rds_instance_class
  db_name                  = var.db_name
  db_username              = var.db_username
  db_password              = var.db_password
  security_group_id        = module.security_groups.rds_security_group_id
  environment              = var.environment
  multi_az                 = var.rds_multi_az
  storage_type             = var.rds_storage_type
  backup_retention_period  = var.rds_backup_retention_period
}

module "alb" {
  source             = "./modules/alb"  
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  environment        = var.environment
}


module "ec2" {
  source               = "./modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.ec2_instance_type
  private_subnet_ids   = module.vpc.private_subnet_ids
  instance_count       = var.ec2_instance_count
  vpc_id               = module.vpc.vpc_id
  security_group_id    = module.security_groups.ec2_security_group_id
  environment          = var.environment
  key_name             = var.ec2_key_name
  iam_instance_profile = module.iam.ec2_instance_profile_name
  allowed_cidr_blocks  = var.allowed_http_cidr_blocks
  s3_bucket_name       = var.s3_bucket_name
  db_credentials_arn   = var.db_credentials_arn
  # Pass ALB variables to EC2 module
  target_group_arn     = module.alb.target_group_arn
  alb_security_group_ids = module.alb.alb_security_group_ids
}
