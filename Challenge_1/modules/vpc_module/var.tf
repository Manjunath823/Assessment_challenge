variable "env_name" {
    default = "Production"
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1a"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "database_subnets" {
  type    = list(string)
  default = ["10.0.201.0/24", "10.0.202.0/24"]
}

variable "cidr_vpc" {
  default = "10.0.0.0/16"
}