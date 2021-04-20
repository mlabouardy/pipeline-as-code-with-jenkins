// Grafana ELB
resource "aws_elb" "grafana_elb" {
  subnets                   = [for subnet in aws_subnet.public_subnets : subnet.id]
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_grafana_sg.id]
  instances                 = [aws_instance.grafana.id]

  listener {
    instance_port      = 3000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:3000"
    interval            = 5
  }

  tags = {
    Name   = "grafana_elb"
    Author = var.author
  }
}