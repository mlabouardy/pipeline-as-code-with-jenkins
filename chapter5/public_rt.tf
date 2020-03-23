// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.management.id

  tags = {
    Name   = "igw_${var.vpc_name}"
    Author = var.author
  }
}

// Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.management.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name   = "public_rt_${var.vpc_name}"
    Author = var.author
  }
}

// Associate public subnets to public route table
resource "aws_route_table_association" "public" {
  count          = var.public_subnets_count
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}