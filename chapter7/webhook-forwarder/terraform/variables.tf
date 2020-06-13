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

variable "jenkins_url" {
  type = string
  description = "Jenkins hostname URL"
}