resource "aws_security_group" "elb_logstash_sg" {
  name        = "elb_logstash_sg"
  description = "Allow https traffic"
  vpc_id      = var.vpc_id

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
    Name   = "elb_logstash_sg"
    Author = var.author
  }
}

resource "aws_security_group" "logstash_sg" {
  name        = "logstash_sg"
  description = "Allow traffic on port 5000 and enable SSH from bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  ingress {
    from_port       = "5000"
    to_port         = "5000"
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_logstash_sg.id]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "logstash_sg"
    Author = var.author
  }
}

