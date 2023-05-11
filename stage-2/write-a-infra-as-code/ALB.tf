# Create the load balancer
resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nginx_sg.id]
  subnets            = ["subnet-1", "subnet-2"]
}

# Create the load balancer listener
resource "aws_lb_listener" "nginx_alb_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

# Create the load balancer target group
resource "aws_lb_target_group" "nginx_tg" {
  name        = "example"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc"
}

resource "aws_security_group" "nginx_sg" {
  name_prefix = "nginx-sg"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}