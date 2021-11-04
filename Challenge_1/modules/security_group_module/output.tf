output "security_group" {
  value = {
    lb     = module.load_balancer_sg.security_group.id
    db     = module.db_sg.security_group.id
    websvr = module.web_server_sg.security_group.id
  }
}