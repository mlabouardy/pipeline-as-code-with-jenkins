// Provided at runtime

variable "region" {
  type = string
  description = "AWS region"
}

variable "shared_credentials_file" {
  type = string
  description = "AWS credentials file path"
}

variable "aws_profile" {
  type = string
  description = "AWS profile"
}

variable "author" {
  type = string
  description = "Created by"
}

variable "vpc_id" {
  type        = string
  description = "Management VPC ID"
}

variable "bastion_sg_id" {
  type        = string
  description = "Bastion security group ID"
}

variable "private_subnets" {
  type = list
  description = "VPC private subnets IDs"
}

variable "public_subnets" {
  type = list
  description = "VPC public subnets IDs"
}

variable "key_name" {
  type = string
  description = "SSH KeyPair name"
}

variable "hosted_zone_id" {
  type = string
  description = "Route53 hosted zone id"
}

variable "domain_name" {
  type = string
  description = "Domain name"
}

variable "ssl_arn" {
  type = string
  description = "ACM SSL ARN"
}


// Default values
variable "nexus_instance_type" {
  type = string
  description = "Nexus OSS EC2 instance type"
  default = "t2.large"
}