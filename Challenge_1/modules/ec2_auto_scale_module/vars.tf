variable "env_name" {
    default = "production"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "vpc" {
  type = any
}

variable "security_group" {
  type = any
}

variable "web_port" {
    default = "8080"
}

variable "app_port" {
    default = "8090"
}

variable "max_instance_size" {
    default = "2"
}
