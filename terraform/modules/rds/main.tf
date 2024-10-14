resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier              = "${var.environment}-db-instance"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0.32"  # Change to a supported version
  instance_class          = "db.t3.micro"  # Change to a supported instance class
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [var.security_group_id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = var.multi_az
  storage_type            = var.storage_type
  backup_retention_period = var.backup_retention_period

  tags = {
    Name        = "${var.environment}-db-instance"
    Environment = var.environment
  }
}


