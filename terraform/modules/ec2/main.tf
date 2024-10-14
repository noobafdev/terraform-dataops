resource "aws_instance" "app" {
  count                         = var.instance_count
  ami                           = var.ami_id
  instance_type                 = var.instance_type
  subnet_id                     = element(var.private_subnet_ids, count.index % length(var.private_subnet_ids))
  vpc_security_group_ids        = [aws_security_group.app_sg.id]
  associate_public_ip_address   = false
  key_name                      = var.key_name
  iam_instance_profile          = var.iam_instance_profile

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y python3-pip awscli jq
    sudo snap install amazon-ssm-agent --classic
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent

    pip3 install fastapi uvicorn pymysql python-dotenv

    # Download the application zip from S3
    aws s3 cp s3://${var.s3_bucket_name}/fastapi-app.zip /home/ubuntu/

    # Unzip and set up the application
    unzip /home/ubuntu/fastapi-app.zip -d /home/ubuntu/app
    cd /home/ubuntu/app

    # Retrieve database credentials from Secrets Manager
    DB_SECRET=$(aws secretsmanager get-secret-value --secret-id ${var.db_credentials_arn} --query 'SecretString' --output text)
    DB_USER=$(echo $DB_SECRET | jq -r '.DB_USER')
    DB_PASSWORD=$(echo $DB_SECRET | jq -r '.DB_PASSWORD')
    DB_HOST=$(echo $DB_SECRET | jq -r '.DB_HOST')
    DB_NAME=$(echo $DB_SECRET | jq -r '.DB_NAME')

    # Export environment variables and create .env file
    echo "DB_USER=$DB_USER" > .env
    echo "DB_PASSWORD=$DB_PASSWORD" >> .env
    echo "DB_HOST=$DB_HOST" >> .env
    echo "DB_NAME=$DB_NAME" >> .env

    # Install dependencies and start the FastAPI service using systemd
    pip3 install -r requirements.txt
    sudo bash -c 'cat <<EOT > /etc/systemd/system/fastapi.service
    [Unit]
    Description=FastAPI Application
    After=network.target

    [Service]
    User=ubuntu
    WorkingDirectory=/home/ubuntu/app
    ExecStart=/usr/local/bin/uvicorn main:app --host 0.0.0.0 --port 8000
    Restart=always

    [Install]
    WantedBy=multi-user.target
    EOT'

    # Start and enable the service
    sudo systemctl daemon-reload
    sudo systemctl start fastapi.service
    sudo systemctl enable fastapi.service
  EOF

  tags = {
    Name        = "${var.environment}-app-instance-${count.index}"
    Environment = var.environment
  }
}

# Attach EC2 Instances to the ALB Target Group
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  count            = var.instance_count
  target_group_arn = var.target_group_arn  # Target group ARN passed from the ALB module
  target_id        = aws_instance.app[count.index].id
  port             = 8000  # Port where FastAPI is running
}

# Security Group for the EC2 instances to allow traffic from ALB
resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-app-sg"
  description = "Allow inbound traffic for the application"
  vpc_id      = var.vpc_id

  # Allow inbound traffic on port 8000 from the ALB security group
  ingress {
    from_port                = 8000
    to_port                  = 8000
    protocol                 = "tcp"
    security_groups = var.alb_security_group_ids  # Use security_groups instead of source_security_group_id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-app-sg"
    Environment = var.environment
  }
}
