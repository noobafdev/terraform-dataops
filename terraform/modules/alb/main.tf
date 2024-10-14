# Create multiple security groups with dynamic names using count
resource "aws_security_group" "alb_sg" {
  count       = length(var.public_subnet_ids)  # Create one security group per public subnet (or adjust count as needed)
  name        = "${var.environment}-alb-sg-${count.index}"
  description = "Allow inbound HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-alb-sg-${count.index}"
    Environment = var.environment
  }
}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  
  # Use dynamic security groups created with count
  security_groups    = aws_security_group.alb_sg[*].id  # Pass all security group IDs to the ALB
  subnets            = var.public_subnet_ids  # ALB needs to be in public subnets

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
  }
}

# Target Group for EC2 instances
resource "aws_lb_target_group" "app_tg" {
  name     = "${var.environment}-tg"
  port     = 8000  # Port where FastAPI is running
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name        = "${var.environment}-tg"
    Environment = var.environment
  }
}

# Listener for HTTP traffic
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
