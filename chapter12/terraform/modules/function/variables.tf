variable "name" {
    type = string
    description = "A unique name for your Lambda Function"
}

variable "handler" {
    type = string
    description = "The function entrypoint in your code"
}

variable "runtime" {
    type = string
    description = "Function runtime environment"
}


variable "environment" {
  default     = null
  description = "The Lambda environment's configuration settings."
  type        = map(string)
}
