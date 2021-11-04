module "load_balancer_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [{
    port        = 80
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = 8080
      security_groups = [module.load_balancer_sg.security_group.id]
    },
    {
      port        = 22
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
}

module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [{
    port            = "${var.db_port}"
    security_groups = [module.web_server_sg.security_group.id]
  }]
}