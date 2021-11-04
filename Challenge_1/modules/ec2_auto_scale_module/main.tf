resource "aws_iam_instance_profile" "iam_profile" {
  name = "iam_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "iam_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["Manjunath"]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = "${file("ssh_key.pub")}"
}
resource "aws_launch_template" "web_server" {
  name_prefix   = "${var.env_name}"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  user_data     = "${file("install_apache.sh")}"
  key_name      = "${aws_key_pair.ssh_key.key_name}"
  iam_instance_profile {
    name = "${aws_iam_instance_profile.iam_profile.name}"
  }
  vpc_security_group_ids = "${var.security_group.web_server}"
}

locals {
  env_name_string = "service_${var.env_name}"
}

resource "aws_autoscaling_group" "web_server" {
  name                = "${var.env_name_string}-asg"
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = "${var.vpc.public_subnets}"
  target_group_arns   = "${module.alb.target_group_arns}"
  launch_template {
    id      = "${aws_launch_template.web_server.id}"
    version = $"{aws_launch_template.web_server.latest_version"}
  }
}

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  name               = "${var.env_name}"
  load_balancer_type = "application"
  vpc_id             = "${var.vpc.vpc_id}"
  subnets            = "${var.vpc.public_subnets}"
  security_groups    = ["${var.security_group.load_balancer_sg}"]

  http_tcp_listeners = [
    {
      port               = 80,
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    { name_prefix      = "web_server",
      backend_protocol = "HTTP",
      backend_port     = "${web_port}"
      target_type      = "instance"
    }
  ]
}

resource "aws_launch_template" "app_server" {
  name_prefix   = "${var.env_name}"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.ssh_key.key_name}"
  iam_instance_profile {
    name = "${aws_iam_instance_profile.iam_profile.name}"
  }
  vpc_security_group_ids = "${var.security_group.web_server}"
}


resource "aws_autoscaling_group" "app_server" {
  name                = "${var.env_name_string}-asg"
  min_size            = 1
  max_size            = "${var.max_instance_size}"
  vpc_zone_identifier = "${var.vpc.private_subnets}"
  target_group_arns   = "${module.alb.target_group_arns}"
  launch_template {
    id      = "${aws_launch_template.web_server.id}"
    version = $"{aws_launch_template.web_server.latest_version"}
  }
}

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  name               = "${var.env_name}"
  load_balancer_type = "application"
  vpc_id             = "${var.vpc.vpc_id}"
  subnets            = "${var.vpc.private_subnets}"
  security_groups    = ["${var.security_group.load_balancer_sg}"]

  http_tcp_listeners = [
    {
      port               = 80,
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    { name_prefix      = "app_server",
      backend_protocol = "HTTP",
      backend_port     = "${var.app_port}"
      target_type      = "instance"
    }
  ]
}