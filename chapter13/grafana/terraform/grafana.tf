data "aws_ami" "grafana" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["grafana-*"]
  }
}
  
resource "aws_instance" "grafana" {
  ami                    = data.aws_ami.grafana.id
  instance_type          = var.grafana_instance_type
  key_name               = aws_key_pair.management.id
  vpc_security_group_ids = [aws_security_group.grafana_sg.id]
  subnet_id              = element(aws_subnet.private_subnets, 0).id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = false
  }

  tags = {
    Author = var.author
    Name = "grafana"
    Stack = "Monitoring"
  }
}