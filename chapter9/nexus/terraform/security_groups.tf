resource "aws_security_group" "elb_nexus_sg" {
  name        = "elb_nexus_sg"
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
    Name   = "elb_nexus_sg"
    Author = var.author
  }
}

resource "aws_security_group" "elb_registry_sg" {
  name        = "elb_registry_sg"
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
    Name   = "elb_registry_sg"
    Author = var.author
  }
}


resource "aws_security_group" "nexus_sg" {
  name        = "nexus_sg"
  description = "Allow traffic on port 8081 & 5000 and enable SSH from bastion host"
  vpc_id      = aws_vpc.management.id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }

  ingress {
    from_port       = "8081"
    to_port         = "8081"
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_nexus_sg.id]
  }

  ingress {
    from_port       = "5000"
    to_port         = "5000"
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_registry_sg.id]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "nexus_sg"
    Author = var.author
  }
}

