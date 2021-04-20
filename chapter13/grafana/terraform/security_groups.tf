resource "aws_security_group" "elb_grafana_sg" {
  name        = "elb_grafana_sg"
  description = "Allow https traffic"
  vpc_id      = aws_vpc.management.id

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
    Name   = "elb_grafana_sg"
    Author = var.author
  }
}

resource "aws_security_group" "grafana_sg" {
  name        = "grafana_sg"
  description = "Allow traffic on port 3000 and enable SSH from bastion host"
  vpc_id      = aws_vpc.management.id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }

  ingress {
    from_port       = "3000"
    to_port         = "3000"
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_grafana_sg.id]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "grafana_sg"
    Author = var.author
  }
}

