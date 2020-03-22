resource "aws_vpc" "management" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = {
    Name   = var.vpc_name
    Author = var.author
  }
}