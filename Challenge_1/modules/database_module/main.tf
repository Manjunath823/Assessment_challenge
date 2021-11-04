resource "aws_db_instance" "database" {
  allocated_storage      = "${var.storage}"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  identifier             = "${var.env_name}-db"
  name                   = "pets"
  username               = "${var.username}"
  password               = "${var.pass}"
  db_subnet_group_name   = "${var.vpc.database_subnet_group}"
  vpc_security_group_ids = ["${var.security_group.db}"]
  skip_final_snapshot    = true
}