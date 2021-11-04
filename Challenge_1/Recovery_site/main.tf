module "recovery_vpc" {
  source           = "./modules/vpc_module"
  env_name         = "recovery"
  cidr             = "10.1.0.0/16"
  azs              = ["us-east-2a"]
  private_subnets  = "10.1.1.0/24"
  public_subnets   = "10.1.101.0/24"
  database_subnets = "10.1.201.0/24"
}

module "recovery_sg" {
  source  = "./modules/security_group_module"
  db_port = "3306"
}

module "recovery_auto_scale" {
  source            = "./modules/ec2_auto_scale_module"
  env_name          = "recovery"
  vpc               = "${module.recovery_vpc.vpc}"
  security_group    = "${module.recovery_sg.security_group}"
  web_port          = "8080"
  app_port          = "8090"
  max_instance_size = "1"
}

module "recovery_database" {
  source   = "./modules/database_module"
  env_name = "recovery"
  username = "admin"
  pass     = "unencryptedpassword"
}

