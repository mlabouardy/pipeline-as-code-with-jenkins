// logstash ELB
resource "aws_elb" "logstash_elb" {
  subnets                   = var.public_subnets
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_logstash_sg.id]
  instances                 = [aws_instance.logstash.id]

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
    Name   = "logstash_elb"
    Author = var.author
  }
}