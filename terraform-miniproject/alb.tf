resource "aws_security_group" "alb_sg" {
  name   = "alb-sg-${var.student_name}"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "Accessing vote from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "my_alb" {
  name               = "alb-${var.student_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnet[*].id

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "vote_tg" {
  name     = "vote-tg-${var.student_name}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "result_tg" {
  name     = "result-tg-${var.student_name}"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "vote_attach" {
  count            = length(aws_instance.frontend)
  target_group_arn = aws_lb_target_group.vote_tg.arn
  target_id        = aws_instance.frontend[count.index].id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "result_attach" {
  count            = length(aws_instance.frontend)
  target_group_arn = aws_lb_target_group.result_tg.arn
  target_id        = aws_instance.frontend[count.index].id
  port             = 8081
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vote_tg.arn
  }
}

resource "aws_lb_listener_rule" "vote_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vote_tg.arn
  }

  condition {
    path_pattern {
      values = ["/vote*"]
    }
  }
}

resource "aws_lb_listener_rule" "result_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 11

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.result_tg.arn
  }

  condition {
    path_pattern {
      values = ["/result*"]
    }
  }
}