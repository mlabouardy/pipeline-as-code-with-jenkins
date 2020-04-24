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

// Default values

variable "vpc_name" {
  type = string
  description = "VPC name"
  default     = "sandbox"
}

variable "cidr_block" {
  type = string
  description = "VPC CIDR block"
  default     = "10.1.0.0/16"
}

variable "cluster_name" {
  type = string
  description = "EKS cluster name"
  default     = "sandbox"
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