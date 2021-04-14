// elasticsearch ELB
resource "aws_elb" "elasticsearch_elb" {
  subnets                   = [for subnet in aws_subnet.public_subnets : subnet.id]
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_elasticsearch_sg.id]
  instances                 = [aws_instance.elasticsearch.id]

  listener {
    instance_port      = 9200
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9200"
    interval            = 5
  }

  tags = {
    Name   = "elasticsearch_elb"
    Author = var.author
  }
}