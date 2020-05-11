// Visualizer ELB
resource "aws_elb" "visualizer_elb" {
  subnets                   = var.public_subnets
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_visualizer_sg.id]

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"

  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 5
  }

  tags = {
    Name   = "visualizer_elb"
    Author = var.author
  }
}

resource "aws_autoscaling_attachment" "cluster_attach_visualizer_elb" {
  autoscaling_group_name = var.swarm_managers_asg_id
  elb                    = aws_elb.visualizer_elb.id
}

// Movies Store ELB
resource "aws_elb" "movies_store_elb" {
  subnets                   = var.public_subnets
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_movies_store_sg.id]

  listener {
    instance_port      = 3000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"

  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:3000"
    interval            = 5
  }

  tags = {
    Name   = "movies_store_elb"
    Author = var.author
  }
}

resource "aws_autoscaling_attachment" "cluster_attach_movies_store_elb" {
  autoscaling_group_name = var.swarm_workers_asg_id
  elb                    = aws_elb.movies_store_elb.id
}

// Movies Marketplace ELB
resource "aws_elb" "movies_marketplace_elb" {
  subnets                   = var.public_subnets
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_movies_marketplace_sg.id]

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"

  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:80"
    interval            = 5
  }

  tags = {
    Name   = "movies_marketplace_elb"
    Author = var.author
  }
}

resource "aws_autoscaling_attachment" "cluster_attach_movies_marketplace_elb" {
  autoscaling_group_name = var.swarm_workers_asg_id
  elb                    = aws_elb.movies_marketplace_elb.id
}