module "vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  name             = "${var.env_name}"
  cidr             = "${var.cidr_vpc}"
  azs              = "${var.availability_zone_names}"
  private_subnets  = "${var.private_subnets}"
  public_subnets   = "${var.public_subnets}"
  database_subnets = "${var.database_subnets}"

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
}

locals {
  env_name = "string_${var.env_name}"
}

