resource "aws_lb" "aws_alb_server" {
  name = "Alb-for-WordPress-Application"

  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_group_id]
  subnets            = values(var.public_subnet_ids)

  enable_deletion_protection = false

  tags = {
    "Name" = "Load Balancer For App"
  }
}

resource "aws_lb_target_group" "alb_tg_group" {
  name     = "Target-Group-for-ALB-Application"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 10
    interval            = 30
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.aws_alb_server.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.aws_alb_server.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_group.arn
  }
}
