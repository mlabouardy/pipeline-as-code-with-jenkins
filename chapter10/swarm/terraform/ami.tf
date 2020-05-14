// Find latest Docker AMI
data "aws_ami" "docker" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["docker-*"]
  }
}