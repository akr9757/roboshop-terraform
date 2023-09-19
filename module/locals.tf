locals {
  name = var.env != "" ? "${var.component_name}-${var.env}" : var.component_name
  db_commands = [
    "rm -rf roboshop1-shell",
    "git clone https://github.com/akr9757/roboshop1-shell.git",
    "cd roboshop1-shell",
    "sudo bash ${var.component_name}.sh ${var.password}"
  ]
  app_commands = [
    "sudo labauto ansible",
    "ansible-pull -i localhost, -U https://github.com/akr9757/roboshop-ansible.git roboshop.yml -e role_name=${var.component_name} -e env=${var.env}"
  ]
  db_tags = {
    Name = "${var.component_name}-${var.env}"
  }
  app_tags = {
    Name = "${var.component_name}-${var.env}"
    Monitor = "true"
    component = var.component_name
    env = var.env
  }
}


