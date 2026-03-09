# Web Tier ALB
resource "aws_lb" "web" {
  name               = "${var.environment}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets           = var.web_subnet_ids

  tags = {
    Name        = "${var.environment}-web-alb"
    Environment = var.environment
    Tier        = "web"
  }
}

# Web Tier Target Group
resource "aws_lb_target_group" "web" {
  name     = "${var.environment}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
  }

  tags = {
    Name        = "${var.environment}-web-tg"
    Environment = var.environment
    Tier        = "web"
  }
}

# Web Tier Listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Web Tier Instances
resource "aws_instance" "web" {
  count                       = 2
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.web_sg_id]
  subnet_id                   = var.web_subnet_ids[count.index % length(var.web_subnet_ids)]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Web Server $(hostname -f)</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.environment}-web-instance-${count.index + 1}"
    Environment = var.environment
    Tier        = "web"
  }
}

# Attach web instances to target group
resource "aws_lb_target_group_attachment" "web" {
  count            = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

# App Tier Internal ALB
resource "aws_lb" "app" {
  name               = "${var.environment}-app-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets           = var.app_subnet_ids

  tags = {
    Name        = "${var.environment}-app-alb"
    Environment = var.environment
    Tier        = "app"
  }
}

# App Tier Target Group
resource "aws_lb_target_group" "app" {
  name     = "${var.environment}-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
  }

  tags = {
    Name        = "${var.environment}-app-tg"
    Environment = var.environment
    Tier        = "app"
  }
}

# App Tier Listener
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# App Tier Instances
resource "aws_instance" "app" {
  count                  = 2
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.app_sg_id]
  subnet_id              = var.app_subnet_ids[count.index % length(var.app_subnet_ids)]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    # Install Java for Spring Boot apps
    amazon-linux-extras install java-openjdk11 -y
    # Create a simple app server
    mkdir -p /opt/app
    echo "Application Server $(hostname -f) is running" > /opt/app/index.html
    # Simple HTTP server for demo (use proper app server in production)
    nohup python3 -m http.server 8080 --directory /opt/app &
  EOF

  tags = {
    Name        = "${var.environment}-app-instance-${count.index + 1}"
    Environment = var.environment
    Tier        = "app"
  }
}

# Attach app instances to target group
resource "aws_lb_target_group_attachment" "app" {
  count            = length(aws_instance.app)
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app[count.index].id
  port             = 8080
}

# Data source for Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}