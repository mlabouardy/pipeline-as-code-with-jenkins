data "aws_ami" "kibana" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["kibana-*"]
  }
}
  
resource "aws_instance" "kibana" {
  ami                    = data.aws_ami.kibana.id
  instance_type          = var.kibana_instance_type
  key_name               = aws_key_pair.management.id
  vpc_security_group_ids = [aws_security_group.kibana_sg.id]
  subnet_id              = element(aws_subnet.private_subnets, 0).id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = false
  }

  tags = {
    Author = var.author
    Name = "kibana"
    Stack = "Logging"
  }
}