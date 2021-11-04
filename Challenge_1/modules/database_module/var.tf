variable "storage" {
  default = "10"
}

variable "env_name" {
  default = "production"
}

variable "username" {
  default = "admin"
}

variable "pass" {}

variable "vpc" {
  type = any
}

variable "security_group" {
  type = any
}
