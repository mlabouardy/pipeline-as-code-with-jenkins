resource "aws_security_group" "swarm_sg" {
  name        = "swarm_sg_${var.environment}"
  description = "Allow inbound traffic for swarm management and ssh from jenkins & bastion hosts"
  vpc_id      = aws_vpc.sandbox.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id, var.jenkins_sg_id]
  }

  ingress {
    from_port   = "2377"
    to_port     = "2377"
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = "7946"
    to_port     = "7946"
    protocol    = "tcp"
    cidr_blocks =  [var.cidr_block]
  }

  ingress {
    from_port   = "7946"
    to_port     = "7946"
    protocol    = "udp"
    cidr_blocks =  [var.cidr_block]
  }

  ingress {
    from_port   = "4789"
    to_port     = "4789"
    protocol    = "udp"
    cidr_blocks =  [var.cidr_block]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "swarm_sg_${var.environment}"
    Author      = var.author
    Environment = var.environment
  }
}