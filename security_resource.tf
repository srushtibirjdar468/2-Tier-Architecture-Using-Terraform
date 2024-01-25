#security grp for application load balancer
resource "aws_security_group" "alb_sg" {
  name = "alb-sg"
  description = "security group for alb"
  vpc_id = aws_vpc.vpc.id

  ingress  { #inbound rules
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress  {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create alb

resource "aws_lb" "project_alb" {
  name =  "alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [aws_subnet.public-1.id,aws_subnet.public-2.id]
}

#create alb target group
resource "aws_lb_target_group" "project_tg" {
  name = "project-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id
  depends_on = [ aws_vpc.vpc ]
}

#creating target attachment

resource "aws_lb_target_group_attachment" "tg-attach1" {
  target_group_arn = aws_lb_target_group.project_tg.arn
  target_id =  aws_instance.web1.id
  port = 80
  depends_on = [ aws_instance.web1 ]
}

resource "aws_lb_target_group_attachment" "tg-attach2" {
  target_group_arn = aws_lb_target_group.project_tg.arn
  target_id =  aws_instance.web2.id
  port = 80
  depends_on = [ aws_instance.web2 ]
}
#creating listner
resource "aws_lb_listener" "listner_lb" {
  load_balancer_arn = aws_lb.project_alb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.project_tg.arn
  }
}





























