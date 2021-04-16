## Application Load balancer
resource "aws_lb" "app-alb" {
  name               = "app-alb"
  subnets            = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_asg.id]

  tags = {
    Name = "APP ALB"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "APP-TargetGroup" {
  name        = "APP-TargetGroup"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.app_vpc.id
  target_type = "instance"

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = true
  }
  health_check {
    interval            = 30
    path                = "/healthcheck/"
    port                = 3000
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200,202"
  }
  tags = {
    key   = "Name"
    value = "App ALB"
  }
}

# ALB Listener
resource "aws_lb_listener" "app-alb-Listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.APP-TargetGroup.arn
    type             = "forward"
  }
}
