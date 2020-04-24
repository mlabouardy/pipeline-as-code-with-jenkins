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

variable "key_name" {
  type = string
  description = "SSH key pair"
}

variable "availability_zones" {
  type        = list
  description = "List of Availability Zones"
}

variable "bastion_sg_id" {
  type = string
  description = "Bastion host's security group ID"
}

variable "jenkins_sg_id" {
  type = string
  description = "Jenkins's security group ID"
}

// Default values

variable "vpc_name" {
  type = string
  description = "VPC name"
  default     = "sandbox"
}

variable "environment" {
  type = string
  description = "Environment name"
  default     = "sandbox"
}

variable "cidr_block" {
  type = string
  description = "VPC CIDR block"
  default     = "10.1.0.0/16"
}

variable "cluster_name" {
  type = string
  description = "Swarm cluster name"
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

variable "swarm_discovery_bucket" {
  type = string 
  description = "S3 bucket used for cluster discovery"
  default = "swarm-discovery-cluster"
}

variable "manager_instance_type" {
  type = string 
  description = "Swarm manager instance type"
  default = "t2.small"
}

variable "worker_instance_type" {
  type = string 
  description = "Swarm worker instance type"
  default = "t2.large"
}