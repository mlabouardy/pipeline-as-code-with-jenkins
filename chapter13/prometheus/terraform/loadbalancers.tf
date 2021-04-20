// prometheus ELB
resource "aws_elb" "prometheus_elb" {
  subnets                   = [for subnet in aws_subnet.public_subnets : subnet.id]
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_prometheus_sg.id]
  instances                 = [aws_instance.prometheus.id]

  listener {
    instance_port      = 9090
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9090"
    interval            = 5
  }

  tags = {
    Name   = "prometheus_elb"
    Author = var.author
  }
}