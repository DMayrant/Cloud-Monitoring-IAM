resource "aws_lb" "main_alb" {
  name                       = "my-application-load-balancer"
  internal                   = false # Set to true for an internal ALB
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.vpc_sg.id]
  subnets                    = aws_subnet.public_subnet[*].id
  enable_deletion_protection = false
}


resource "aws_lb_target_group" "default" {
  name     = "default-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}
