// Nexus Dashboard ELB
resource "aws_elb" "nexus_elb" {
  subnets                   = [for subnet in aws_subnet.public_subnets : subnet.id]
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_nexus_sg.id]
  instances                 = [aws_instance.nexus.id]

  listener {
    instance_port      = 8081
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8081"
    interval            = 5
  }

  tags = {
    Name   = "nexus_elb"
    Author = var.author
  }
}

// Registry ELB
resource "aws_elb" "registry_elb" {
  subnets                   = [for subnet in aws_subnet.public_subnets : subnet.id]
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_registry_sg.id]
  instances                 = [aws_instance.nexus.id]

  listener {
    instance_port      = 5000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:5000"
    interval            = 5
  }

  tags = {
    Name   = "registry_elb"
    Author = var.author
  }
}