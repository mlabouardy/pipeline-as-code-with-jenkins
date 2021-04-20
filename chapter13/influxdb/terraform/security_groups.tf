resource "aws_security_group" "elb_influxdb_sg" {
  name        = "elb_influxdb_sg"
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
    Name   = "elb_influxdb_sg"
    Author = var.author
  }
}

resource "aws_security_group" "influxdb_sg" {
  name        = "influxdb_sg"
  description = "Allow traffic on port 8086 and enable SSH from bastion host"
  vpc_id      = aws_vpc.management.id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }

  ingress {
    from_port       = "8086"
    to_port         = "8086"
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_influxdb_sg.id]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "influxdb_sg"
    Author = var.author
  }
}

