resource "aws_s3_bucket" "swarm_discovery_bucket" {
  bucket = var.swarm_discovery_bucket
  acl    = "private"

  tags = {
    Author = var.author
    Environment = var.environment
  }
}