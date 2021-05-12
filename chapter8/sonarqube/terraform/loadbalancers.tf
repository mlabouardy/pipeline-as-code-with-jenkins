// SonarQube ELB Security group
resource "aws_security_group" "elb_sonarqube_sg" {
  name        = "elb_sonarqube_sg"
  description = "Allow http & https traffic"
  vpc_id      = aws_vpc.management.id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "elb_sonarqube_sg"
    Author = var.author
  }
}

// SonarQube ELB
resource "aws_elb" "sonarqube_elb" {
  subnets                   = [for subnet in aws_subnet.public_subnets : subnet.id]
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_sonarqube_sg.id]
  instances                 = [aws_instance.sonarqube.id]

  listener {
    instance_port      = 9000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  listener {
    instance_port     = 9000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"

  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9000"
    interval            = 5
  }

  tags = {
    Name   = "sonarqube_elb"
    Author = var.author
  }
}
