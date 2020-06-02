resource "aws_security_group" "elb_kibana_sg" {
  name        = "elb_kibana_sg"
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
    Name   = "elb_kibana_sg"
    Author = var.author
  }
}

resource "aws_security_group" "kibana_sg" {
  name        = "kibana_sg"
  description = "Allow traffic on port 5601 and enable SSH from bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  ingress {
    from_port       = "5601"
    to_port         = "5601"
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_kibana_sg.id]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "kibana_sg"
    Author = var.author
  }
}

