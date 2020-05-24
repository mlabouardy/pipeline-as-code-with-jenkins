variable "name" {
    type = string
    description = "Function name"
}

variable "handler" {
    type = string
    description = "Function entrypoint file path"
}

variable "runtime" {
    type = string
    description = "Function runtime environment"
}
