// Provided at runtime
variable "token" {
    type = string
    description = "DigitalOcean API token"
}

variable "region" {
    type = string
    description = "DigitalOcean region"
}

variable "ssh_fingerprint" {
    type = string
    description = "Public key finger print"
}

variable "jenkins_username" {
  type = string
  description = "Jenkins admin user"
}

variable "jenkins_password" {
  type = string
  description = "Jenkins admin password"
}

variable "jenkins_credentials_id" {
  type = string
  description = "Jenkins workers SSH based credentials id"
}

// Default values
variable "jenkins_master_image" {
    type = string
    description = "Jenkins master image"
    default = "jenkins-master-2.204.1"
}

variable "jenkins_worker_image" {
    type = string
    description = "Jenkins worker image"
    default = "jenkins-worker"
}

variable "jenkins_workers_count" {
    type = number
    description = "Minimum number of workers"
    default = 2
}