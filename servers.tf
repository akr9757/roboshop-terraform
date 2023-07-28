resource "aws_instance" "instance" {
  for_each               = var.components
  ami                    = data.aws_ami.centos.image_id
  instance_type          = each.value[ "instance_type" ]
  vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

  tags = {
    Name = each.value[ "name" ]
  }
}

resource "null_resource" "provisioner" {
  depends on = [aws_instance.instance, aws_route53_record.records]
  fro_each = var.components

  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance[each.value["name"]].private_ip
    }
    inline = [
      "rm -rf roboshop1-shell",
      "git clone https://github.com/akr9757/roboshop1-shell.git",
      "cd roboshop1-shell",
      "sudo bash ${each.value["name"]}.sh ${each.value["password"]}"
    ]
  }
}

resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id = "Z02476638DMPBR5KR64H"
  name    = "${each.value["name"]}-dev.akrdevopsb72.online"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.instance[each.value["name"]].private_ip]
}

