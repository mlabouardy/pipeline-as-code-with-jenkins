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

variable "public_subnets" {
  type = list
  description = "VPC public subnets IDs"
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

variable "environment" {
  type = string
  description = "Environment"
  default = "sandbox"
}

variable "swarm_managers_asg_id" {
    type = string
    description = "Swarm managers autoscaling group name"
    default = "managers_asg_sandbox"
}

variable "swarm_workers_asg_id" {
    type = string
    description = "Swarm workers autoscaling group name"
    default = "workers_asg_sandbox"
}