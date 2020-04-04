// Provided at runtime
variable "subscription_id" {
    type = string
    description = "Subscription id"
}

variable "client_id" {
    type = string
    description = "Client id"
}

variable "client_secret" {
    type = string
    description = "Client secret"
}

variable "tenant_id" {
    type = string
    description = "Tenant id"
}

variable "location" {
    type= string
    description = "Location"
}

variable "resource_group" {
  type = string
  description = "Resource group name"
}

variable "public_ssh_key" {
  type = string
  description = "Public ssh key path"
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
variable "base_cidr_block" {
    type = string
    description = "Network CIDR block"
    default = "10.0.0.0/16"
}

variable "subnets" {
  default = [
    {
      name   = "public-10.0.0.0"
      number = 0
    },
    {
      name   = "public-10.0.1.0"
      number = 1
    },
    {
      name   = "private-10.0.2.0"
      number = 2
    },
    {
      name   = "private-10.0.3.0"
      number = 3
    }
  ]
}

variable "config" {
  type = map
  description = "Authentication credentials"
  default = {
    "os_name" = "jenkins-master"
    "vm_username" = "jenkins"
  }
}

variable "jenkins_vm_size" {
  type = string
  description = "Jenkins instance type"
  default = "Standard_B1ms"
}

variable "jenkins_master_image" {
  type = string
  description = "Jenkins master image"
  default = "jenkins-master-v22041"
}

variable "jenkins_worker_image" {
  type = string
  description = "Jenkins worker image"
  default = "jenkins-worker"
}