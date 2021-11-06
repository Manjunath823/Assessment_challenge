provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}

module "production_vpc" {
  source           = "./modules/vpc_module"
  env_name         = "production"
  cidr             = "10.0.0.0/16"
  azs              = ["us-east-1a", "us-east-1a"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]
}

module "production_sg" {
  source  = "./modules/security_group_module"
  db_port = "3306"
}

module "production_auto_scale" {
  source            = "./modules/ec2_auto_scale_module"
  env_name          = "production"
  vpc               = "${module.production_vpc.vpc}"
  security_group    = "${module.production_sg.security_group}"
  web_port          = "8080"
  app_port          = "8090"
  max_instance_size = "2"
}

module "production_database" {
  source   = "./modules/database_module"
  env_name = "production"
  username = "admin"
  pass     = "unencryptedpassword"
}
