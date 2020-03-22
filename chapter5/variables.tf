variable "region" {
  description = "AWS region"
}

variable "shared_credentials_file" {
  description = "AWS credentials file path"
}

variable "aws_profile" {
  description = "AWS profile"
}

variable "author" {
  description = "Created by"
}

variable "vpc_name" {
  description = "VPC name"
  default     = "management"
}

variable "cidr_block" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}