// Visualizer ELB Security group
resource "aws_security_group" "elb_visualizer_sg" {
  name        = "elb_visualizer_sg"
  description = "Allow http & https traffic"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name   = "elb_visualizer_sg"
    Author = var.author
  }
}

// Movies Store ELB Security group
resource "aws_security_group" "elb_movies_store_sg" {
  name        = "elb_movies_store_sg"
  description = "Allow http & https traffic"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name   = "elb_movies_store_sg"
    Author = var.author
  }
}

// Movies Marketplace ELB Security group
resource "aws_security_group" "elb_movies_marketplace_sg" {
  name        = "elb_movies_marketplace_sg"
  description = "Allow http & https traffic"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name   = "elb_movies_marketplace_sg"
    Author = var.author
  }
}