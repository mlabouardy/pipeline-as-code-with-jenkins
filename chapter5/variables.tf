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

variable "availability_zones" {
  type        = list
  description = "List of Availability Zones"
}

variable "public_key" {
  type = string
  description = "SSH public key path"
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

variable "vpc_name" {
  type = string
  description = "VPC name"
  default     = "management"
}

variable "cidr_block" {
  type = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "public_subnets_count" {
  type = number
  description = "Number of public subnets"
  default = 2
}

variable "private_subnets_count" {
  type = number
  description = "Number of private subnets"
  default = 2
}

variable "bastion_instance_type" {
  type = string
  description = "Bastion instance type"
  default = "t2.micro"
}

variable "jenkins_master_instance_type" {
  type = string
  description = "Jenkins master EC2 instance type"
  default = "t2.large"
}